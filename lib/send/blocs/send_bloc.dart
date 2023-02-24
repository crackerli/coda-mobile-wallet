import 'dart:typed_data';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/send/blocs/send_events.dart';
import 'package:coda_wallet/send/blocs/send_states.dart';
import 'package:coda_wallet/tok_k/top_k.dart';
import 'package:ffi_mina_signer/sdk/mina_signer_sdk.dart';
import 'package:ffi_mina_signer/types/key_types.dart';
import 'package:ffi_mina_signer/util/mina_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/coda_service.dart';
import '../mutation/delegate_token_mutation.dart';
import '../mutation/send_token_mutation.dart';
import '../query/get_account_nonce.dart';

class SendBloc extends
  Bloc<SendEvents, SendStates> {

  late CodaService _service;
  late Uint8List _accountPrivateKey;

  late String to;
  late String from;
  late String? memo;
  late String amount;
  String? fee;
  late bool isDelegation;
  late int accountIndex;
  late bool sendEnabled;
  late bool loading;
  late int nonce;
  late bool isEverstake;

  // this list should have length 3, and 0 is for fastest, 1 for medium, 2 for slow
  List<BigInt> bestFees = [];
  // selected fee index
  int? feeIndex;
  // After fee selection, if the balance is less than user input amount+fee, then we should adjust the send amount
  BigInt? get finalAmount {
    if(null == feeIndex || -1 == feeIndex || bestFees.isEmpty) {
      return BigInt.tryParse(amount);
    }

    BigInt chosenFee = bestFees[feeIndex!];
    BigInt? balance = BigInt.tryParse(globalHDAccounts.accounts![accountIndex]!.balance!);
    BigInt? inputAmount = BigInt.tryParse(amount);
    if(null != balance && null != inputAmount) {
      if(balance < (chosenFee + inputAmount)) {
        // Adjust send amount
        return balance - chosenFee;
      } else {
        return inputAmount;
      }
    } else {
      return inputAmount;
    }
  }

  Future<Signature> _signPayment() async {
    String tempMemo = (null == memo || memo!.isEmpty) ? '' : memo!;
    String? feePayerAddress = from;
    String? senderAddress = from;
    String receiverAddress = to;
    BigInt fee = bestFees[feeIndex!];
    BigInt feeToken = BigInt.from(1);
    int validUntil = 4294967295;
    BigInt tokenId = BigInt.from(1);
    BigInt amount = finalAmount!;
    int tokenLocked = 0;

    int networkId = getCurrentNetworkId();
    print('Current network id using to sending: $networkId');
    Signature signature = await signPayment(MinaHelper.reverse(_accountPrivateKey), tempMemo, feePayerAddress,
      senderAddress, receiverAddress, fee, feeToken, nonce, validUntil, tokenId, amount, tokenLocked, networkId);
    return signature;
  }

  Future<Signature> _signDelegation() async {
    String tempMemo = (null == memo || memo!.isEmpty) ? '' : memo!;
    String? feePayerAddress = from;
    String? senderAddress = from;
    String receiverAddress = to;
    BigInt fee = bestFees[feeIndex!];
    BigInt feeToken = BigInt.from(1);
    int validUntil = 4294967295;
    BigInt tokenId = BigInt.from(1);
    int tokenLocked = 0;

    int networkId = getCurrentNetworkId();
    print('Current network id using to sending: $networkId');
    Signature signature = await signDelegation(MinaHelper.reverse(_accountPrivateKey), tempMemo, feePayerAddress,
      senderAddress, receiverAddress, fee, feeToken, nonce, validUntil, tokenId, tokenLocked, networkId);
    return signature;
  }

  SendBloc(SendStates? state) : super(state!) {
    _service = CodaService();

    bestFees.add(BigInt.from(MINIMAL_FEE_COST));
    bestFees.add(BigInt.from(MINIMAL_FEE_COST));
    bestFees.add(BigInt.from(MINIMAL_FEE_COST));
    feeIndex = -1;
  }

  @override
  Stream<SendStates>
    mapEventToState(SendEvents event) async* {

    if(event is SendActions) {
      yield* _mapSendActionsToStates(event);
      return;
    }

    if(event is GetPooledFee) {
      yield* _mapGetPooledFeeToStates(event);
      return;
    }

    if(event is ChooseFee) {
      yield* _mapFeeChosenToStates(event);
      return;
    }

    if(event is DecryptSeed) {
      yield* _mapDecryptSeedToStates(event);
      return;
    }

    if(event is ClearWrongPassword) {
      yield* _mapClearWrongPasswordToStates(event);
      return;
    }
  }

  Stream<SendStates>
    _mapClearWrongPasswordToStates(ClearWrongPassword event) async* {
    yield SeedPasswordCleared();
    return;
  }

  Stream<SendStates>
    _mapDecryptSeedToStates(DecryptSeed event) async* {
    yield DecryptSeedLoading();

    String? encryptedSeed = await globalSecureStorage.read(key: ENCRYPTED_SEED_KEY);
    print('SendFeeScreen: start to decrypt seed');

    try {
      Uint8List seed = await decryptSeed(encryptedSeed!, event.password);
      _accountPrivateKey = generatePrivateKey(seed, accountIndex);
      yield DecryptSeedSuccess();
    } catch (error) {
      print('Wrong password input while sending');
      yield DecryptSeedFail();
      return;
    }
    return;
  }

  Stream<SendStates>
    _mapFeeChosenToStates(ChooseFee event) async* {
    int index = event.index;
    feeIndex = index;
    yield FeeChosen(index);
  }

  // Get all fees from the network command pool, and rearrange all the fees with topK method.
  // Then we can estimate which fee can included in the coming blocks.
  Stream<SendStates>
    _mapGetPooledFeeToStates(GetPooledFee event) async* {
    final query = event.query;
    final variables = event.variables ?? null;
    try {
      loading = true;
      yield GetPooledFeeLoading();
      final result = await _service.performQuery(query, variables: variables!);
      loading = false;

      if(result.hasException) {
        String error = exceptionHandle(result);
        yield GetPooledFeeFail(error);
        return;
      }

      List<dynamic> feesStr = result.data!['pooledUserCommands'] as List<dynamic>;
      if(feesStr == null || feesStr.length == 0) {
        _calcBestFees(null);
      } else {
        List<BigInt> fees = List<BigInt>.generate(
          feesStr.length, (index) => BigInt.tryParse(feesStr[index]!['fee']) ?? BigInt.from(0));
        _calcBestFees(fees);
      }
      yield GetPooledFeeSuccess(bestFees);
    } catch (e) {
      print(e);
      yield GetPooledFeeFail(e.toString());
    } finally {

    }
  }

  _calcBestFees(List<BigInt>? fees) {
    if(null == fees || fees.length == 0 || fees.length < 3) {
      bestFees.clear();
      bestFees.add(BigInt.from(MINIMAL_FEE_COST));
      bestFees.add(BigInt.from(MINIMAL_FEE_COST));
      bestFees.add(BigInt.from(MINIMAL_FEE_COST));
      return;
    }

    if(fees.length < FEE_COHORT_LENGTH * 2) {
      fees.sort((a, b) => a < b ? 1 : -1);
      bestFees.clear();
      bestFees.add(fees[0] + BigInt.from(MINIMAL_FEE_COST));
      bestFees.add(fees[fees.length - 1] + BigInt.from(MINIMAL_FEE_COST));
      if(fees[fees.length - 1] - BigInt.from(MINIMAL_FEE_COST) < BigInt.from(MINIMAL_FEE_COST)) {
        bestFees.add(BigInt.from(MINIMAL_FEE_COST));
      } else {
        bestFees.add(fees[fees.length - 1] - BigInt.from(MINIMAL_FEE_COST));
      }
      bestFees = bestFees.reversed.toList();
      return;
    }

    List<BigInt> topFees = topK(fees, FEE_COHORT_LENGTH * 2, desc: true);
    bestFees.clear();
    bestFees.add(topFees[0] + BigInt.from(MINIMAL_FEE_COST));
    bestFees.add(topFees[FEE_COHORT_LENGTH - 1] + BigInt.from(MINIMAL_FEE_COST));
    bestFees.add(topFees[FEE_COHORT_LENGTH * 2 - 1] + BigInt.from(MINIMAL_FEE_COST));
    bestFees = bestFees.reversed.toList();
    return;
  }

  Stream<SendStates>
  _mapSendActionsToStates(SendActions event) async* {
    yield SendActionsLoading();

    // 1. Get account nonce
    {
      Map<String, dynamic> variables = Map<String, dynamic>();
      variables['publicKey'] = from;

      try {
        final result = await _service.performQuery(GET_NONCE_QUERY, variables: variables);

        if (result.hasException) {
          String error = exceptionHandle(result);
          yield SendActionsFail(error);
          return;
        }

        if (null == result.data || null == result.data!['account']) {
          yield SendActionsFail('Get nonce server failed!');
          return;
        }

        Map<String, dynamic> account = result.data!['account'];
        if (null == account['nonce']) {
          nonce = 0;
        } else {
          if (null == account['inferredNonce']) {
            nonce = int.tryParse(account['nonce']) ?? 0;
          } else {
            // Always using inferred nonce if it is not null
            nonce = int.tryParse(account['inferredNonce']) ?? 0;
          }
        }
      } catch (e) {
        print(e);
        yield SendActionsFail(e.toString());
      }
    }

    // 2. sign messages and send
    {
      Map<String, dynamic> variables = Map<String, dynamic>();
      variables['from'] = from;
      variables['to'] = to;
      if(!isDelegation) {
        variables['amount'] = finalAmount.toString();
      }
      String tempMemo = (null == memo || memo!.isEmpty) ? '' : memo!;
      variables['memo'] = tempMemo;
      variables['fee'] = bestFees[feeIndex!].toString();
      variables['nonce'] = nonce;
      variables['validUntil'] = 4294967295;

      if(isDelegation) {
        Signature signature = await _signDelegation();
        variables['field'] = signature.rx;
        variables['scalar'] = signature.s;
      } else {
        Signature signature = await _signPayment();
        variables['field'] = signature.rx;
        variables['scalar'] = signature.s;
      }

      String mutation;
      if(isDelegation) {
        mutation = SEND_DELEGATION_MUTATION;
      } else {
        mutation = SEND_PAYMENT_MUTATION;
      }

      try {
        final result = await _service.performMutation(mutation, variables: variables);

        if (result.hasException) {
          String error = exceptionHandle(result);
          yield SendActionsFail(error);
          return;
        }

        // 3. report to Everstake if needed
        yield SendActionsSuccess();
      } catch (e) {
        print(e);
        yield SendActionsFail(e.toString());
      }
    }
  }
}

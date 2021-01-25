import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/send/blocs/pooled_fee_entity.dart';
import 'package:coda_wallet/send/blocs/send_events.dart';
import 'package:coda_wallet/send/blocs/send_states.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_k/top_k.dart';
import '../../service/coda_service.dart';

class SendBloc extends
  Bloc<SendEvents, SendStates> {

  CodaService _service;

  String to;
  String from;
  String memo;
  String amount;
  String fee;
  int account;
  bool sendEnabled;
  bool loading;
  int nonce;
  // this list should have length 3, and 0 is for fastest, 1 for medium, 2 for slow
  List<BigInt> bestFees = List<BigInt>();
  // selected fee index
  int feeIndex;

  SendBloc(SendStates state) : super(state) {
    _service = CodaService();

    bestFees.add(BigInt.from(MINIMAL_FEE_COST));
    bestFees.add(BigInt.from(MINIMAL_FEE_COST));
    bestFees.add(BigInt.from(MINIMAL_FEE_COST));
    feeIndex = -1;
  }

  bool checkFeeValid() {
    if(null == fee || fee.isEmpty) {
      sendEnabled = false;
      return false;
    }

    if(!checkNumeric(fee)) {
      sendEnabled = false;
      return false;
    }

    sendEnabled = true;
    return true;
  }

  @override
  Stream<SendStates>
    mapEventToState(SendEvents event) async* {
    if(event is Send) {
      yield* _mapSendToStates(event);
      return;
    }

    if(event is FeeValidate) {
      yield* _mapFeeValidateToStates(event);
      return;
    }

    if(event is GetNonce) {
      yield* _mapGetNonceToStates(event);
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

    if(event is InputWrongPassword) {
      yield* _mapWrongPasswordToStates(event);
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
    _mapWrongPasswordToStates(InputWrongPassword event) async* {
    yield SeedPasswordWrong();
    return;
  }

  Stream<SendStates>
    _mapFeeChosenToStates(ChooseFee event) async* {
    int index = event.index;
    feeIndex = index;
    yield FeeChosen(index);
  }

  Stream<SendStates>
    _mapGetPooledFeeToStates(GetPooledFee event) async* {
    final query = event.query;
    final variables = event.variables ?? null;
    try {
      loading = true;
      yield GetPooledFeeLoading();
      final result = await _service.performMutation(query, variables: variables);
      loading = false;

      if(null == result || result.hasException) {
        String error = exceptionHandle(result);
        yield GetPooledFeeFail(error);
        return;
      }

      List<dynamic> feesStr = result.data['pooledUserCommands'] as List<dynamic>;
      List<BigInt> fees = List.generate(feesStr.length, (index) => BigInt.tryParse(feesStr[index]['fee']));
      _calcBestFees(fees);
      yield GetPooledFeeSuccess(bestFees);
    } catch (e) {
      print(e);
      yield GetPooledFeeFail(e.toString());
    } finally {

    }
  }

  _calcBestFees(List<BigInt> fees) {
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
    _mapFeeValidateToStates(FeeValidate event) async* {
    if(checkFeeValid()) {
      yield FeeValidated();
      return;
    }

    yield FeeInvalidated();
  }

  Stream<SendStates>
    _mapSendToStates(Send event) async* {

    final mutation = event.mutation;
    final variables = event.variables ?? null;

    try {
      loading = true;
      yield SendLoading(null);
      final result = await _service.performMutation(mutation, variables: variables);
      loading = false;

      if(null == result || result.hasException) {
        String error = exceptionHandle(result);
        yield SendFail(error);
        return;
      }

      yield SendSuccess(null);
    } catch (e) {
      print(e);
      yield SendFail(e.toString());
    } finally {

    }
  }

  Stream<SendStates>
    _mapGetNonceToStates(GetNonce event) async* {
    final mutation = event.query;
    final variables = event.variables ?? null;

    try {
      loading = true;
      yield GetNonceLoading();
      final result = await _service.performMutation(mutation, variables: variables);
      loading = false;

      if(null == result || result.hasException) {
        String error = exceptionHandle(result);
        yield GetNonceFail(error);
        return;
      }

      if(null == result.data['account']['nonce']) {
        nonce = 0;
      } else {
        nonce = int.parse(result.data['account']['nonce']);
      }
      yield GetNonceSuccess();
    } catch (e) {
      print(e);
      yield GetNonceFail(e.toString());
    } finally {

    }
  }

}

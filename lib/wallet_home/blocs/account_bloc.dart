import 'dart:convert';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/service/common_https_service.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_entity.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:coda_wallet/util/providers_utils.dart';
import 'package:coda_wallet/wallet_home/query/account_query.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/coda_service.dart';
import 'account_events.dart';
import 'account_states.dart';
import 'package:coda_wallet/util/safe_map.dart';

class AccountBloc extends
  Bloc<AccountEvents, AccountStates> {

  late CodaService _service;
  late IndexerService _indexerService;

  AccountBloc(AccountStates state) : super(state) {
    _service = CodaService();
    _indexerService = IndexerService();
  }

  AccountStates get initState => GetAccountsLoading();

  @override
  Stream<AccountStates>
    mapEventToState(AccountEvents event) async* {

    if(event is GetAccounts) {
      yield* _mapGetAccountsToStates(event);
      return;
    }

  }

  Stream<AccountStates>
    _mapGetAccountsToStates(GetAccounts event) async* {

    if(globalHDAccounts.accounts!.isEmpty) {
      return;
    }

    try {
      yield GetAccountsLoading();
      for(AccountBean? account in globalHDAccounts.accounts!) {
        Map<String, dynamic> variables = Map<String, dynamic>();
        variables['publicKey'] = account!.address;
        final result = await _service.performQuery(ACCOUNT_QUERY, variables: variables);

        if(result.hasException || null == result.data) {
          throw Exception('One of Mina accounts syncing failed');
        }

        print('Get account ${account!.address} successfully');
        dynamic accounts = result.data!['accounts'];
        // If the account is null, then we can say this account is not active
        if((accounts as List).isEmpty) {
          account!.balance = '0';
          account!.isActive = false;
          account!.stakingAddress = '';
        } else { // We use only the first account
          Map<String, dynamic> tempAccount = accounts[0] as Map<String, dynamic>;
          SafeMap safeAccount = SafeMap(tempAccount);
          String balance = safeAccount['balance']['total'].value;
          String publicKey = safeAccount['publicKey'].value;
          String stakingAddress = safeAccount['delegateAccount']['publicKey'].value;

          if(account!.address == publicKey) {
            account.balance = balance;
            account.isActive = true;
            account.stakingAddress = stakingAddress;
          } else {
            print('Account got not match it saved on disk!!!');
          }
        }
      }

      print('All accounts synced!!!');
      // Save global accounts info
      Map accountsJson = globalHDAccounts.toJson();
      await globalSecureStorage.write(
        key: GLOBAL_ACCOUNTS_KEY, value: json.encode(accountsJson));

      print('All accounts written into disk!!!');
      yield GetAccountsSuccess();

      bool result = await _getExchangeInfo();
      if(result) {
        yield GetExchangeInfoSuccess(null);
      } else {
        yield GetExchangeInfoFail(null);
      }

      await _getProviders();
    } catch (e) {
      yield GetAccountsFail();
      print('Wallet home exception: ${e.toString()}');
    } finally {

    }
  }

  // Just store all registered pool in local storage for future usage.
  _getProviders() async {
    try {
      Response response = await _indexerService.getProviders();

      if (response.statusCode != 200) {
        return;
      }

      // Convert provider list to map for quick access.
      ProvidersEntity? providersEntity = ProvidersEntity.fromMap(response.data);
      if (null == providersEntity || null == providersEntity.stakingProviders) {
        return;
      }

      storeProvidersMap(providersEntity.stakingProviders);
      print('Get providers done!!');
    } catch (e) {
      print('Error happen when get providers: ${e.toString()}');
    } finally {}
  }

  Future<bool> _getExchangeInfo() async {
    try {
      Response response = await _indexerService.getExchangeInfo();

      if(response.statusCode != 200) {
        return false;
      }

      Map<String, dynamic> data = response.data as Map<String, dynamic>;
      if(null != data['price'] && data['price']!.isNotEmpty) {
        globalPreferences.setString(NOMICS_PRICE_KEY, data['price']!);
        print('Get exchange info done!!');
      } else {
        print('Get exchange info error!!');
        return false;
      }

      return true;
    } catch (e) {
      print('Error happen when get exchange info: ${e.toString()}');
      return false;
    } finally {}
  }
}

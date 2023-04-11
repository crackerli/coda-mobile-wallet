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

class AccountBloc extends Bloc<AccountEvents, AccountStates> {

  late CodaService _service;
  late IndexerService _indexerService;
  bool _hasProvidersLoaded = false;

  int accountIndex = 0;
  bool isAccountLoading = false;

  String? get publicKey => globalHDAccounts.accounts?[accountIndex]?.address ?? 'Initial accounts';
  bool get accountStaking {
    AccountBean? account = globalHDAccounts.accounts?[accountIndex];
    if(null == account) {
      return false;
    }

    if(account.isActive ?? false) {
      if(null != account.stakingAddress && account.stakingAddress!.isNotEmpty && account.stakingAddress != account.address) {
        return true;
      }
    }
    return false;
  }

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
      isAccountLoading = true;
      AccountBean? account = globalHDAccounts.accounts?[accountIndex];

      if(null == account) {
        throw Exception('Account syncing failed');
      }

      Map<String, dynamic> variables = Map<String, dynamic>();
      variables['publicKey'] = account.address;
      final result = await _service.performQuery(ACCOUNT_QUERY, variables: variables);

      if(result.hasException || null == result.data) {
        throw Exception('Account syncing failed');
      }

      print('Get account ${account.address} successfully');
      dynamic accounts = result.data!['accounts'];
      // If the account is null, then we can say this account is not active
      if((accounts as List).isEmpty) {
        account.balance = '0';
        account.isActive = false;
        account.stakingAddress = '';
      } else { // We use only the first account
        Map<String, dynamic> tempAccount = accounts[0] as Map<String, dynamic>;
        SafeMap safeAccount = SafeMap(tempAccount);
        String balance = safeAccount['balance']['total'].value;
        String publicKey = safeAccount['publicKey'].value;
        String stakingAddress = safeAccount['delegateAccount']['publicKey'].value;

        if(account.address == publicKey) {
          account.balance = balance;
          account.isActive = true;
          account.stakingAddress = stakingAddress;
        } else {
          print('Account got not match it saved on disk!!!');
        }
      }

      print('All accounts synced!!!');
      // Save global accounts info
      Map accountsJson = globalHDAccounts.toJson();
      await globalSecureStorage.write(
        key: GLOBAL_ACCOUNTS_KEY, value: json.encode(accountsJson));

      print('All accounts written into disk!!!');

      // Get Providers api is very slow, get only once when app startup
      print('Start to get providers');
      if(!_hasProvidersLoaded) {
        await _getProviders();
        print('Get providers finished');
        _hasProvidersLoaded = true;
      } else {
        print('No need to get providers');
      }

      // This may always be fail because of binance blocked
      if(event.getExchangeInfo) {
        bool result = await _getExchangeInfo();
        if (result) {
          print('Get exchange info success');
        } else {
          print('Get exchange info fail');
        }
      }

      isAccountLoading = false;
      yield GetAccountsSuccess();
    } catch (e) {
      isAccountLoading = false;
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

      await storeProvidersMap(providersEntity.stakingProviders);
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

      //Map<String, dynamic> data = response.data as Map<String, dynamic>;
      List<dynamic>? data = response.data as List<dynamic>?;
      if(null == data || data.isEmpty) {
        print('Can not find mina-usdt pair');
        return false;
      }

      Map<String, dynamic> minaPair = data[0];

      if(null != minaPair['price_usd'] && minaPair['price_usd'].isNotEmpty) {
        await globalPreferences.setString(NOMICS_PRICE_KEY, minaPair['price_usd']);
        print('Get exchange info done, price=${minaPair['price_usd']}');
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

import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/service/indexer_service.dart';
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

    final query = ACCOUNT_QUERY;
    Map<String, dynamic> variables = Map<String, dynamic>();
    variables['publicKey'] = globalHDAccounts.accounts![event.index]?.address;

    try {
      yield GetAccountsLoading();
      final result = await _service.performQuery(query, variables: variables);
      if(null == result || result.hasException || null == result.data) {
        // If one account fail, we continue to next if not finished
        if(event.index >= globalHDAccounts.accounts!.length - 1) {
          print('1. Get all accounts info finished');
          yield GetAccountsFinished();
          getProviders();
        } else {
          print('1. To get account ${event.index + 1}');
          add(GetAccounts(event.index + 1));
        }
        return;
      }

      // Parse data from Json map, convert it to safe map for safe nested access
      dynamic accounts = result.data!['accounts'];
      if((accounts as List).isEmpty) {
        globalHDAccounts.accounts![event.index]?.balance = '0';
        globalHDAccounts.accounts![event.index]?.isActive = false;
        globalHDAccounts.accounts![event.index]?.stakingAddress = '';
      } else {
        // If the account is null, then we can say this account is not active
        // We use only the first account
        Map<String, dynamic> account = accounts[0] as Map<String, dynamic>;
        SafeMap safeAccount = SafeMap(account);
        String balance = safeAccount['balance']['total'].value;
        String publicKey = safeAccount['publicKey'].value;
        String stakingAddress = safeAccount['delegateAccount']['publicKey'].value;
        // find it in global accounts
        for(int i = 0; i < globalHDAccounts.accounts!.length; i++) {
          AccountBean? account = globalHDAccounts.accounts![i];
          if(account!.address == publicKey) {
            account.balance = balance;
            account.isActive = true;
            account.stakingAddress = stakingAddress;
            break;
          }
        };
      }
      if(event.index >= globalHDAccounts.accounts!.length - 1) {
        print('2. Get all accounts info finished');
        yield GetAccountsFinished();
        getProviders();
        return;
      }

      // Continue to get next account info
      print('2. To get account ${event.index + 1}');
      add(GetAccounts(event.index + 1));
    } catch (e) {
      print(e);
    } finally {

    }
  }

  getProviders() async {
    try {
      Response response = await _indexerService.getProviders();

      if (null == response || response.statusCode != 200) {
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

}

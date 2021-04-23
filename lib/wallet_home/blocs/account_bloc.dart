import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:coda_wallet/wallet_home/query/account_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/coda_service.dart';
import 'account_events.dart';
import 'account_states.dart';
import 'package:coda_wallet/util/safe_map.dart';

class AccountBloc extends
  Bloc<AccountEvents, AccountStates> {

  CodaService _service;

  AccountBloc(AccountStates state) : super(state) {
    _service = CodaService();
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
    variables['publicKey'] = globalHDAccounts?.accounts[event?.index]?.address;

    try {
      yield GetAccountsLoading();
      final result = await _service.performQuery(query, variables: variables);
      if(null == result || result.hasException || null == result.data) {
        // If one account fail, we continue to next if not finished
        if(event.index >= globalHDAccounts.accounts.length - 1) {
          yield GetAccountsFinished();
        } else {
          add(GetAccounts(event.index + 1));
        }
        return;
      }

      // Parse data from Json map, convert it to safe map for safe nested access
      dynamic accounts = result.data['accounts'];
      if((accounts as List).isEmpty) {
        globalHDAccounts?.accounts[event?.index]?.balance = '0';
        globalHDAccounts?.accounts[event?.index]?.isActive = false;
      } else {
        // If the account is null, then we can say this account is not active
        // We use only the first account
        Map<String, dynamic> account = accounts[0] as Map<String, dynamic>;
        SafeMap safeAccount = SafeMap(account);
        String balance = safeAccount['balance']['total'].value;
        String publicKey = safeAccount['publicKey'].value;
        // find it in global accounts
        for(int i = 0; i < globalHDAccounts.accounts.length; i++) {
          AccountBean account = globalHDAccounts.accounts[i];
          if(account.address == publicKey) {
            account.balance = balance;
            account.isActive = true;
            break;
          }
        };
      }
      if(event.index >= globalHDAccounts.accounts.length - 1) {
        yield GetAccountsFinished();
        return;
      }

      // Continue to get next account info
      add(GetAccounts(event.index + 1));
    } catch (e) {
      print(e);
    } finally {

    }
  }
}

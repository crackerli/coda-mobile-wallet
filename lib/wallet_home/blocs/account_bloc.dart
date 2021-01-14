import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:coda_wallet/wallet_home/query/account_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/coda_service.dart';
import 'account_events.dart';
import 'account_states.dart';

class AccountBloc extends
  Bloc<AccountEvents, AccountStates> {

  CodaService _service;

  AccountBloc(AccountStates state) : super(state) {
    _service = CodaService();
  }

  newCodaService() => _service = CodaService();

  AccountStates get initState => GetAccountsLoading(null);

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
    variables['publicKey'] = globalHDAccounts.accounts[event.index].address;

    try {
      final result = await _service.performQuery(query, variables: variables);
      String balance = result.data['account']['balance']['total'];
      String publicKey = result.data['account']['publicKey'];
      // find it in global accounts
      for(int i = 0; i < globalHDAccounts.accounts.length; i++) {
        AccountBean account = globalHDAccounts.accounts[i];
        if(account.address == publicKey) {
          account.balance = balance;
          break;
        }
      }
      if(event.index >= globalHDAccounts.accounts.length - 1) {
        yield GetAccountsFinished();
        return;
      }

      add(GetAccounts(event.index + 1));
    } catch (e) {
      print(e);
    } finally {

    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'account_txns_events.dart';
import 'account_txns_states.dart';
import '../../service/coda_service.dart';

class AccountTxnsBloc extends Bloc<AccountTxnsEvents, AccountTxnsStates> {
  CodaService service;

  AccountTxnsBloc(AccountTxnsStates state) : super(state) {
    service = CodaService();
  }

  @override
  AccountTxnsStates get initialState => Loading();

  @override
  Stream<AccountTxnsStates> mapEventToState(AccountTxnsEvents event) async* {
    if (event is FetchAccountTxnsData) {
      yield* _mapFetchAccountTxnsDataToStates(event);
    }
  }

  Stream<AccountTxnsStates> _mapFetchAccountTxnsDataToStates(FetchAccountTxnsData event) async* {
    final query = event.query;
    final variables = event.variables ?? null;

    try {
      final result = await service.performQuery(query, variables: variables);

      if (result.hasException) {
        print('graphQLErrors: ${result.exception.graphqlErrors.toString()}');
        print('clientErrors: ${result.exception.clientException.toString()}');
        yield LoadDataFail(result.exception.graphqlErrors[0]);
      } else {
        yield LoadDataSuccess(result.data);
      }
    } catch (e) {
      print(e);
      yield LoadDataFail(e.toString());
    }
  }
}

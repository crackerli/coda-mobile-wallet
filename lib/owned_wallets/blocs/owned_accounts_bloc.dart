import 'package:flutter_bloc/flutter_bloc.dart';
import 'owned_accounts_events.dart';
import 'owned_accounts_states.dart';
import '../../service/coda_service.dart';

class OwnedAccountsBloc extends Bloc<OwnedAccountsEvents, OwnedAccountsStates> {
  CodaService service;

  OwnedAccountsBloc(OwnedAccountsStates state) : super(state) {
    service = CodaService();
  }

  @override
  OwnedAccountsStates get initialState => Loading();

  @override
  Stream<OwnedAccountsStates> mapEventToState(OwnedAccountsEvents event) async* {
    if (event is FetchOwnedAccountsData) {
      yield* _mapFetchOwnedAccountsDataToStates(event);
    }
  }

  Stream<OwnedAccountsStates> _mapFetchOwnedAccountsDataToStates(FetchOwnedAccountsData event) async* {
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

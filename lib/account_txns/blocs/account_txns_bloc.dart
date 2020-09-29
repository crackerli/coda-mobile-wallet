import 'package:coda_wallet/account_txns/blocs/account_txns_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'account_txns_events.dart';
import 'account_txns_states.dart';
import '../../service/coda_service.dart';

class AccountTxnsBloc extends Bloc<AccountTxnsEvents, AccountTxnsStates> {
  CodaService _service;
  List<AccountTxn> _accountTxns;

  AccountTxnsBloc(AccountTxnsStates state) : super(state) {
    _service = CodaService();
    _accountTxns = List<AccountTxn>();
  }

  AccountTxnsStates get initState => FetchAccountTxnsLoading();

  @override
  Stream<AccountTxnsStates> mapEventToState(AccountTxnsEvents event) async* {
    if (event is FetchAccountTxns) {
      yield* _mapFetchAccountTxnsToStates(event);
    }
  }

  Stream<AccountTxnsStates>
    _mapFetchAccountTxnsToStates(FetchAccountTxns event) async* {

    final query = event.query;
    final variables = event.variables ?? null;

    try {
      yield FetchAccountTxnsLoading();
      final result = await _service.performQuery(query, variables: variables);

      if (result.hasException) {
        print('account txns graphql errors: ${result.exception.graphqlErrors.toString()}');
        print('account txns client errors: ${result.exception.clientException.toString()}');
        yield FetchAccountTxnsFail(result.exception.graphqlErrors[0]);
        return;
      }

      final List<dynamic> transactions =
        result.data['blocks']['nodes'] as List<dynamic>;

      _accountTxns = transactions
        .map((dynamic element) => _createAccountTxn(element))
        .toList();

      yield FetchAccountTxnsSuccess(_accountTxns);
    } catch (e) {
      print(e);
      yield FetchAccountTxnsFail(e.toString());
    }
  }

  AccountTxn _createAccountTxn(dynamic element) {
    Map<String, dynamic> transaction = element['transactions'] as Map<String, dynamic>;
    Map<String, dynamic> userCommand = transaction['userCommands'][0] as Map<String, dynamic>;

    return AccountTxn(
      userCommandHash: userCommand['hash'] as String,
      userCommandMemo: userCommand['memo'] as String,
      fee: userCommand['fee'] as String,
      toAccount: userCommand['to'] as String,
      amount: userCommand['amount'] as String,
      fromAccount: userCommand['from'] as String,
      nonce: userCommand['fromAccount']['nonce'] as String,
      coinbaseAccount: transaction['coinbaseReceiverAccount']['publicKey'] as String,
      coinbase: transaction['coinbase'] as String
    );
  }
}

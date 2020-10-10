import 'package:coda_wallet/account_txns/blocs/account_txns_models.dart';
import 'package:coda_wallet/types/list_operation_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'account_txns_events.dart';
import 'account_txns_states.dart';
import '../../service/coda_service.dart';

class AccountTxnsBloc extends Bloc<AccountTxnsEvents, AccountTxnsStates> {
  CodaService _service;
  List<AccountTxn> _accountTxns;
  String _lastCursor;
  bool _hasNextPage;
  bool _isTxnsLoading = false;
  ListOperationType _listOperation;

  AccountTxnsBloc(AccountTxnsStates state) : super(state) {
    _service = CodaService();
    _accountTxns = List<AccountTxn>();
    _lastCursor = null;
    _hasNextPage = false;
    _isTxnsLoading = false;
    _listOperation = ListOperationType.NONE;
  }

  AccountTxnsStates get initState => RefreshAccountTxnsLoading();

  get lastCursor => _lastCursor;
  get hasNextPage => _hasNextPage;
  get isTxnsLoading => _isTxnsLoading;
  get listOperation => _listOperation;

  set isTxnsLoading(bool txnsLoading) {
    _isTxnsLoading = txnsLoading;
  }

  set listOperation(ListOperationType type) {
    _listOperation = type;
  }

  appendLoadMore() {
    // Construct a fake item to delegate load more item
    AccountTxn loadMore = AccountTxn(coinbase: 'load_more');
    _accountTxns.add(loadMore);
  }

  removeLoadMore() {
    if(null == _accountTxns || _accountTxns.length == 0) {
      return;
    }

    AccountTxn accountTxn = _accountTxns.elementAt(_accountTxns.length - 1);
    if(accountTxn.coinbase == 'load_more') {
      _accountTxns.removeLast();
    }
  }

  @override
  Stream<AccountTxnsStates> mapEventToState(AccountTxnsEvents event) async* {
    if(event is RefreshAccountTxns) {
      yield* _mapRefreshAccountTxnsToStates(event);
    }

    if(event is MoreAccountTxns) {
      yield* _mapMoreAccountTxnsToStates(event);
    }
  }

  Stream<AccountTxnsStates>
    _mapMoreAccountTxnsToStates(MoreAccountTxns event) async* {

    final query = event.query;
    final variables = event.variables ?? null;

    try {
      _isTxnsLoading = true;
      appendLoadMore();
      yield MoreAccountTxnsLoading(_accountTxns);
      final result = await _service.performQuery(query, variables: variables);

      if (result.hasException) {
        print('account txns graphql errors: ${result.exception.graphqlErrors.toString()}');
        yield MoreAccountTxnsFail(result.exception.graphqlErrors[0]);
        return;
      }

      final List<dynamic> transactions =
      result.data['blocks']['nodes'] as List<dynamic>;
      List<AccountTxn> tmpTxns = List<AccountTxn>();
      tmpTxns = transactions
          .map((dynamic element) => _createAccountTxn(element))
          .toList();

      removeLoadMore();
      _accountTxns.addAll(tmpTxns);
      _hasNextPage = result.data['blocks']['pageInfo']['hasNextPage'];
      _lastCursor = result.data['blocks']['pageInfo']['lastCursor'];

      yield MoreAccountTxnsSuccess(_accountTxns);
      _isTxnsLoading = false;
      _listOperation = ListOperationType.NONE;
    } catch (e) {
      print(e);
      yield MoreAccountTxnsFail(e.toString());
      _isTxnsLoading = false;
      _listOperation = ListOperationType.NONE;
    }
  }

  Stream<AccountTxnsStates>
    _mapRefreshAccountTxnsToStates(RefreshAccountTxns event) async* {

    final query = event.query;
    final variables = event.variables ?? null;

    try {
      _isTxnsLoading = true;
      yield RefreshAccountTxnsLoading();
      final result = await _service.performQuery(query, variables: variables);

      if (result.hasException) {
        print('account txns graphql errors: ${result.exception.graphqlErrors.toString()}');
        yield RefreshAccountTxnsFail(result.exception.graphqlErrors[0]);
        return;
      }

      final List<dynamic> transactions =
        result.data['blocks']['nodes'] as List<dynamic>;
      _accountTxns.clear();
      _accountTxns = transactions
        .map((dynamic element) => _createAccountTxn(element))
        .toList();

      _hasNextPage = result.data['blocks']['pageInfo']['hasNextPage'];
      _lastCursor = result.data['blocks']['pageInfo']['lastCursor'];

      yield RefreshAccountTxnsSuccess(_accountTxns);
      _isTxnsLoading = false;
      _listOperation = ListOperationType.NONE;
    } catch (e) {
      print(e);
      yield RefreshAccountTxnsFail(e.toString());
      _isTxnsLoading = false;
      _listOperation = ListOperationType.NONE;
    }
  }

  AccountTxn _createAccountTxn(dynamic element) {
    Map<String, dynamic> transaction = element['transactions'] as Map<String, dynamic>;
    List<dynamic> userCommandList = transaction['userCommands'] as List<dynamic>;
    String dateTime = element['protocolState']['blockchainState']['date'] as String;

    List<UserCommand> userCommands = List<UserCommand>();

    if(userCommandList.length == 0) {
      userCommands = [];
    } else {
      userCommands = userCommandList
        .map((dynamic element) {
          return UserCommand(
            userCommandHash: element['hash'] as String,
            userCommandMemo: element['memo'] as String,
            fee: element['fee'] as String,
            toAccount: element['to'] as String,
            amount: element['amount'] as String,
            fromAccount: element['from'] as String,
            nonce: element['fromAccount']['nonce'] as String
          );
      })
      .toList();
    }

    return AccountTxn(
        userCommands: userCommands,
        coinbaseAccount: transaction['coinbaseReceiverAccount']['publicKey'] as String,
        coinbase: transaction['coinbase'] as String,
        dateTime: dateTime
    );
  }
}

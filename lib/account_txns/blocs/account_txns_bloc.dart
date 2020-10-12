import 'package:coda_wallet/account_txns/blocs/account_txns_entity.dart';
import 'package:coda_wallet/types/list_operation_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'account_txns_events.dart';
import 'account_txns_states.dart';
import '../../service/coda_service.dart';

class AccountTxnsBloc extends Bloc<AccountTxnsEvents, AccountTxnsStates> {
  CodaService _service;
  String _lastCursor;
  bool _hasNextPage;
  bool _isTxnsLoading = false;
  ListOperationType _listOperation;
  // User commands merged from both pool and blocks
  List<MergedUserCommand> _mergedUserCommands;
  AccountStatus _accountStatus;
  AccountDetail _accountDetail;
  String _publicKey;

  AccountTxnsBloc(AccountTxnsStates state, String publicKey) : super(state) {
    _service = CodaService();
    _lastCursor = null;
    _hasNextPage = false;
    _isTxnsLoading = false;
    _listOperation = ListOperationType.NONE;
    _publicKey = publicKey;
    _mergedUserCommands = List<MergedUserCommand>();
    _accountStatus = AccountStatus();
    _accountDetail = AccountDetail();
    _accountDetail.accountStatus = _accountStatus;
    _accountDetail.mergedUserCommands = _mergedUserCommands;
  }

  AccountTxnsStates get initState => RefreshAccountTxnsLoading(_accountDetail);

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
    MergedUserCommand loadMore = MergedUserCommand();
    loadMore.coinbase = 'load_more';
    _mergedUserCommands.add(loadMore);
  }

  removeLoadMore() {
    if(null == _mergedUserCommands || _mergedUserCommands.length == 0) {
      return;
    }

    MergedUserCommand last = _mergedUserCommands.elementAt(_mergedUserCommands.length - 1);
    if(last.coinbase == 'load_more') {
      _mergedUserCommands.removeLast();
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
      yield MoreAccountTxnsLoading(_accountDetail);
      final result = await _service.performQuery(query, variables: variables);

      if (result.hasException) {
        print('account txns graphql errors: ${result.exception.graphqlErrors.toString()}');
        yield MoreAccountTxnsFail(result.exception.graphqlErrors[0]);
        return;
      }

      List<dynamic> nodes;
      if(null != result.data['blocks']) {
        nodes = result.data['blocks']['nodes'] as List<dynamic>;
      }

      removeLoadMore();
      _mergeUserCommandsFromNodes(nodes);

      _hasNextPage = result.data['blocks']['pageInfo']['hasNextPage'];
      _lastCursor = result.data['blocks']['pageInfo']['lastCursor'];

      yield MoreAccountTxnsSuccess(_accountDetail);
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
      yield RefreshAccountTxnsLoading(_accountDetail);
      final result = await _service.performQuery(query, variables: variables);

      if(result.hasException) {
        print('account txns graphql errors: ${result.exception.graphqlErrors.toString()}');
        yield RefreshAccountTxnsFail(result.exception.graphqlErrors[0]);
        return;
      }

      if(null == result.data) {
        yield RefreshAccountTxnsFail('No data found!');
        return;
      }

      _mergedUserCommands.clear();

      List<dynamic> pooledUserCommands = result.data['pooledUserCommands'] as List<dynamic>;
      List<dynamic> nodes;
      if(null != result.data['blocks']) {
        nodes =
          result.data['blocks']['nodes'] as List<dynamic>;
      }

      _mergeUserCommandsFromPool(pooledUserCommands);
      _mergeUserCommandsFromNodes(nodes);

      _hasNextPage = result.data['blocks']['pageInfo']['hasNextPage'];
      _lastCursor = result.data['blocks']['pageInfo']['lastCursor'];
      _accountDetail.accountStatus.publicKey = _publicKey;
      _accountDetail.accountStatus.balance = result.data['wallet']['balance']['total'];
      _accountDetail.accountStatus.locked = result.data['wallet']['locked'];

      yield RefreshAccountTxnsSuccess(_accountDetail);
      _isTxnsLoading = false;
      _listOperation = ListOperationType.NONE;
    } catch (e) {
      print(e);
      yield RefreshAccountTxnsFail(e.toString());
      _isTxnsLoading = false;
      _listOperation = ListOperationType.NONE;
    }
  }

  _mergeUserCommandsFromPool(List<dynamic> pooledUserCommands) {
    if(null == pooledUserCommands || 0 == pooledUserCommands.length) {
      return;
    }

    for(int i = 0; i < pooledUserCommands.length; i++) {
      if(null == pooledUserCommands[i]) {
        continue;
      }
      MergedUserCommand mergedUserCommand = MergedUserCommand();
      mergedUserCommand.to = pooledUserCommands[i]['to'];
      mergedUserCommand.isDelegation = pooledUserCommands[i]['isDelegation'];
      mergedUserCommand.nonce = pooledUserCommands[i]['nonce'];
      mergedUserCommand.amount = pooledUserCommands[i]['amount'];
      mergedUserCommand.fee = pooledUserCommands[i]['fee'];
      mergedUserCommand.from = pooledUserCommands[i]['from'];
      mergedUserCommand.hash = pooledUserCommands[i]['hash'];
      mergedUserCommand.memo = pooledUserCommands[i]['memo'];
      mergedUserCommand.isPooled = true;
      mergedUserCommand.dateTime = '';
      mergedUserCommand.coinbase = '';
      mergedUserCommand.isMinted = false;
      _mergedUserCommands.add(mergedUserCommand);
    }
  }

  _mergeUserCommandsFromNodes(List<dynamic> nodes) {
    if(null == nodes || 0 == nodes.length) {
      return;
    }

    for(int i = 0; i < nodes.length; i++) {
      if(null == nodes[i] || null == nodes[i]['transactions']) {
        continue;
      }
      if(null != nodes[i]['transactions']['userCommands']) {
        List<dynamic> userCommands = nodes[i]['transactions']['userCommands'];
        for(int j = 0; j < userCommands.length; j++) {
          if(null == userCommands[j]) {
            continue;
          }
          MergedUserCommand mergedUserCommand = MergedUserCommand();
          mergedUserCommand.to = userCommands[j]['to'];
          mergedUserCommand.isDelegation = userCommands[j]['isDelegation'];
          mergedUserCommand.nonce = userCommands[j]['nonce'];
          mergedUserCommand.amount = userCommands[j]['amount'];
          mergedUserCommand.fee = userCommands[j]['fee'];
          mergedUserCommand.from = userCommands[j]['from'];
          mergedUserCommand.hash = userCommands[j]['hash'];
          mergedUserCommand.memo = userCommands[j]['memo'];
          mergedUserCommand.isPooled = false;
          mergedUserCommand.dateTime = nodes[i]['protocolState']['blockchainState']['date'];
          mergedUserCommand.coinbase = '';
          mergedUserCommand.isMinted = false;
          _mergedUserCommands.add(mergedUserCommand);
        }
      }
      // Process coinbase
      if(_publicKey == nodes[i]['transactions']['coinbaseReceiverAccount']['publicKey']) {
        MergedUserCommand mergedUserCommand = MergedUserCommand();
        mergedUserCommand.to = '';
        mergedUserCommand.isDelegation = false;
        mergedUserCommand.nonce = 0;
        mergedUserCommand.amount = '';
        mergedUserCommand.fee = '';
        mergedUserCommand.from = '';
        mergedUserCommand.hash = '';
        mergedUserCommand.memo = '';
        mergedUserCommand.isPooled = false;
        mergedUserCommand.dateTime = nodes[i]['protocolState']['blockchainState']['date'];
        mergedUserCommand.coinbase = nodes[i]['transactions']['coinbase'];
        mergedUserCommand.isMinted = true;
        _mergedUserCommands.add(mergedUserCommand);
      }
    }
  }
}

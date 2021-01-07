import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/txns/blocs/txns_events.dart';
import 'package:coda_wallet/txns/blocs/txns_states.dart';
import 'package:coda_wallet/types/list_operation_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/coda_service.dart';
import 'txns_entity.dart';

class TxnsBloc extends Bloc<TxnsEvents, TxnsStates> {
  CodaService _service;
  String _lastCursor;
  bool _hasNextPage;
  bool _isTxnsLoading = false;
  ListOperationType _listOperation;
  // User commands merged from both pool and blocks
  List<MergedUserCommand> _mergedUserCommands;
  String _publicKey;

  TxnsBloc(TxnsStates state) : super(state) {
    _service = CodaService();
    _lastCursor = null;
    _hasNextPage = false;
    _isTxnsLoading = false;
    _listOperation = ListOperationType.NONE;
//    _publicKey = publicKey;
    _mergedUserCommands = List<MergedUserCommand>();
  }

  TxnsStates get initState => RefreshTxnsLoading(null);

  get lastCursor => _lastCursor;
  get hasNextPage => _hasNextPage;
  get isTxnsLoading => _isTxnsLoading;
  get listOperation => _listOperation;
  get publicKey => _publicKey;

  set isTxnsLoading(bool txnsLoading) {
    _isTxnsLoading = txnsLoading;
  }

  set listOperation(ListOperationType type) {
    _listOperation = type;
  }

  set publicKey(String publicKey) => _publicKey = publicKey;

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
  Stream<TxnsStates> mapEventToState(TxnsEvents event) async* {
    if(event is RefreshTxns) {
      yield* _mapRefreshTxnsToStates(event);
      return;
    }

    if(event is MoreTxns) {
      yield* _mapMoreTxnsToStates(event);
      return;
    }
  }

  Stream<TxnsStates>
    _mapMoreTxnsToStates(MoreTxns event) async* {

    final query = event.query;
    final variables = event.variables ?? null;

    try {
      _isTxnsLoading = true;
      appendLoadMore();
      yield MoreTxnsLoading(_mergedUserCommands);
      final result = await _service.performQuery(query, variables: variables);

      if(null == result || result.hasException) {
        String error = exceptionHandle(result);
        yield MoreTxnsFail(error);
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

      yield MoreTxnsSuccess(_mergedUserCommands);
      _isTxnsLoading = false;
      _listOperation = ListOperationType.NONE;
    } catch (e) {
      print(e);
      yield MoreTxnsFail(e.toString());
      _isTxnsLoading = false;
      _listOperation = ListOperationType.NONE;
    }
  }

  Stream<TxnsStates>
    _mapRefreshTxnsToStates(RefreshTxns event) async* {

    final query = event.query;
    final variables = event.variables ?? null;

    try {
      _isTxnsLoading = true;
      yield RefreshTxnsLoading(_mergedUserCommands);
      final result = await _service.performQuery(query, variables: variables);

      if(null == result || result.hasException) {
        String error = exceptionHandle(result);
        yield RefreshTxnsFail(error);
        return;
      }

      if(null == result.data) {
        yield RefreshTxnsFail('No data found!');
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

      yield RefreshTxnsSuccess(_mergedUserCommands);
      _isTxnsLoading = false;
      _listOperation = ListOperationType.NONE;
    } catch (e) {
      print(e);
      yield RefreshTxnsFail(e.toString());
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

      // TODO: Here maybe a bug in graphql server, the filter will return some item not related to the publicKey, need to confirm with Mina Team
      if(pooledUserCommands[i]['to'] != _publicKey && pooledUserCommands[i]['from'] != _publicKey) {
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
          // TODO: Here maybe a bug in graphql server, the filter will return some item not related to the publicKey, need to confirm with Mina Team
          if(userCommands[j]['from'] != _publicKey && userCommands[j]['to'] != _publicKey) {
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

      Map<String, dynamic> coinbaseReceiverAccount = nodes[i]['transactions']['coinbaseReceiverAccount'];
      // Process coinbase
      if(null != coinbaseReceiverAccount && _publicKey == coinbaseReceiverAccount['publicKey']) {
        MergedUserCommand mergedUserCommand = MergedUserCommand();
        mergedUserCommand.to = _publicKey;
        mergedUserCommand.isDelegation = false;
        mergedUserCommand.nonce = 0;
        mergedUserCommand.amount = nodes[i]['transactions']['coinbase'];
        mergedUserCommand.fee = '';
        mergedUserCommand.from = 'coinbase';
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

import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/txns/blocs/txns_events.dart';
import 'package:coda_wallet/txns/blocs/txns_states.dart';
import 'package:coda_wallet/txns/query/confirmed_txns_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/coda_service.dart';
import 'txns_entity.dart';

class TxnsBloc extends Bloc<TxnsEvents, TxnsStates> {
  CodaService _service;
  CodaService _serviceFromHttp;
  bool isTxnsLoading = false;
  // User commands merged from both pool and archive
  List<MergedUserCommand> mergedUserCommands;
  int accountIndex = 0;
  int currentFilter = 1;
  List<String> txnFilters = ['ALL', 'SENT', 'RECEIVED', 'STAKED', 'CANCEL'];

  get publicKey => globalHDAccounts.accounts[accountIndex].address;

  TxnsBloc(TxnsStates state) : super(state) {
    _service = CodaService();
    _serviceFromHttp = CodaService.fromHttp("https://graphql.minaexplorer.com");
    isTxnsLoading = false;
    mergedUserCommands = List<MergedUserCommand>();
  }

  TxnsStates get initState => RefreshPooledTxnsLoading(null);

  @override
  Stream<TxnsStates> mapEventToState(TxnsEvents event) async* {
    if(event is RefreshConfirmedTxns) {
      yield* _mapRefreshConfirmedTxnsToStates(event);
      return;
    }

    if(event is RefreshPooledTxns) {
      yield* _mapRefreshPooledTxnsToStates(event);
      return;
    }

    if(event is ChangeFilter) {
      yield* _mapChangeFilterToStates(event);
    }
  }

  Stream<TxnsStates>
    _mapChangeFilterToStates(ChangeFilter event) async* {
    yield FilterChanged();
  }

  Stream<TxnsStates>
    _mapRefreshConfirmedTxnsToStates(RefreshConfirmedTxns event) async* {

    final query = event.query;
    final variables = event.variables ?? null;

    try {
      isTxnsLoading = true;
 //     yield RefreshConfirmedTxnsLoading(mergedUserCommands);
      final result = await _serviceFromHttp.performQuery(query, variables: variables);

      if(null == result || result.hasException) {
        String error = exceptionHandle(result);
        yield RefreshConfirmedTxnsFail(error);
        return;
      }

      List<dynamic> transactions = result.data['transactions'];
      _mergeUserCommandsFromArchiveNode(transactions);

      yield RefreshConfirmedTxnsSuccess(mergedUserCommands);
      isTxnsLoading = false;
    } catch (e) {
      print(e);
      yield RefreshConfirmedTxnsFail(e.toString());
      isTxnsLoading = false;
    }
  }

  Stream<TxnsStates>
    _mapRefreshPooledTxnsToStates(RefreshPooledTxns event) async* {

    final query = event.query;
    final variables = event.variables ?? null;

    try {
      isTxnsLoading = true;
      yield RefreshPooledTxnsLoading(mergedUserCommands);
      final result = await _service.performQuery(query, variables: variables);

      if(null == result || result.hasException) {
        String error = exceptionHandle(result);
        yield RefreshPooledTxnsFail(error);
        return;
      }

      if(null == result.data) {
        yield RefreshPooledTxnsFail('No data found!');
        return;
      }

      mergedUserCommands.clear();
      List<dynamic> pooledUserCommands = result.data['pooledUserCommands'] as List<dynamic>;
      _mergeUserCommandsFromPool(pooledUserCommands);

      {
        Map<String, dynamic> variables = Map<String, dynamic>();
        variables['from'] = publicKey;
        variables['to'] = publicKey;
        add(RefreshConfirmedTxns(CONFIRMED_TXNS_QUERY, variables: variables));
      }
      isTxnsLoading = true;
    } catch (e) {
      print(e);
      yield RefreshPooledTxnsFail(e.toString());
      isTxnsLoading = false;
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

      // TODO: Here maybe a bug in graphql server,
      // the filter will return some item not related to the publicKey, need to confirm with Mina Team
      if(pooledUserCommands[i]['to'] != publicKey && pooledUserCommands[i]['from'] != publicKey) {
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
      mergedUserCommands.add(mergedUserCommand);
    }
  }

  _mergeUserCommandsFromArchiveNode(List<dynamic> transactions) {
    if(null == transactions || 0 == transactions.length) {
      return;
    }

    for(int i = 0; i < transactions.length; i++) {
      if(null == transactions[i]) {
        continue;
      }

      MergedUserCommand mergedUserCommand = MergedUserCommand();
      mergedUserCommand.to = transactions[i]['to'];
      mergedUserCommand.isDelegation = (transactions[i]['kind'] as String) == 'STAKE_DELEGATION';
      mergedUserCommand.nonce = transactions[i]['nonce'];
      mergedUserCommand.amount = transactions[i]['amount'];
      mergedUserCommand.fee = transactions[i]['fee'];
      mergedUserCommand.from = transactions[i]['from'];
      mergedUserCommand.hash = transactions[i]['hash'];
      mergedUserCommand.memo = transactions[i]['memo'];
      mergedUserCommand.isPooled = false;
      mergedUserCommand.dateTime =//transactions[i]['dateTime'];
        DateTime.parse(transactions[i]['dateTime']).millisecondsSinceEpoch.toString();
      mergedUserCommands.add(mergedUserCommand);
    }
  }
}

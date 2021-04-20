import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/service/indexer_service.dart';
import 'package:coda_wallet/txns/blocs/txns_events.dart';
import 'package:coda_wallet/txns/blocs/txns_states.dart';
import 'package:coda_wallet/txns/query/confirmed_txns_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/coda_service.dart';
import 'indexer_txns_entity.dart';
import 'txns_entity.dart';

class TxnsBloc extends Bloc<TxnsEvents, TxnsStates> {
  CodaService _service;
  IndexerService _indexerService;
  bool isTxnsLoading = false;
  // User commands merged from both pool and archive
  List<MergedUserCommand> mergedUserCommands;
  int accountIndex = 0;
  int currentFilter = 0;
  List<String> txnFilters = ['ALL', 'SENT', 'RECEIVED', 'STAKED', 'CANCEL'];

  get filteredUserCommands {
    List<MergedUserCommand> commands = List<MergedUserCommand>();
    if(mergedUserCommands == null || mergedUserCommands.length == 0) {
      return commands;
    }

    // Get sent filtered list
    if(currentFilter == 1) {
      for(int i = 0; i < mergedUserCommands.length; i++) {
        if(!mergedUserCommands[i].isDelegation && mergedUserCommands[i].from == publicKey) {
          commands.add(mergedUserCommands[i]);
        }
      }
      return commands;
    }

    // Get received filtered list
    if(currentFilter == 2) {
      for(int i = 0; i < mergedUserCommands.length; i++) {
        if(!mergedUserCommands[i].isDelegation && mergedUserCommands[i].to == publicKey) {
          commands.add(mergedUserCommands[i]);
        }
      }
      return commands;
    }

    // Get staked filtered list
    if(currentFilter == 3) {
      for(int i = 0; i < mergedUserCommands.length; i++) {
        if(mergedUserCommands[i].isDelegation) {
          commands.add(mergedUserCommands[i]);
        }
      }
      return commands;
    }

    // Default return all list
    return mergedUserCommands;
  }

  get publicKey => globalHDAccounts.accounts[accountIndex].address;

  TxnsBloc(TxnsStates state) : super(state) {
    _service = CodaService();
    _indexerService = IndexerService();
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
      return;
    }

    if(event is ChangeAccount) {
      yield* _mapChangeAccountToStates(event);
      return;
    }
  }

  Stream<TxnsStates>
    _mapChangeAccountToStates(ChangeAccount event) async* {
    mergedUserCommands.clear();
    yield AccountChanged();
    return;
  }

  Stream<TxnsStates>
    _mapChangeFilterToStates(ChangeFilter event) async* {
    yield FilterChanged(filteredUserCommands);
    return;
  }

  Stream<TxnsStates>
    _mapRefreshConfirmedTxnsToStates(RefreshConfirmedTxns event) async* {

    try {
      isTxnsLoading = true;
      final result = await _indexerService.getTransactions(publicKey);

      if(null == result) {
        String error = 'Unknown Error!';
        yield RefreshConfirmedTxnsFail(error);
        return;
      }

      if(result.statusCode != 200) {
        String error = result.statusMessage;
        yield RefreshConfirmedTxnsFail(error);
        return;
      }

      List<dynamic> data = result.data;

      List<IndexerTxnEntity> transactions = List<IndexerTxnEntity>();

      if(null != data && data.length > 0) {
        data.forEach((element) {
          transactions.add(IndexerTxnEntity.fromMap(element));
        });
      }
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
      // Figment's indexer server is one block height behind the latest,
      // so we need to read the latest block from best chain.
      List<dynamic> bestChain = result.data['bestChain'];
      if(null != bestChain && bestChain.length > 0) {
        // We get only one block, the latest.
        _parseUserCommandsFromBestChain(bestChain[0]);
      }

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

  // Parse user commands from best chain, with the latest block height
  _parseUserCommandsFromBestChain(Map<String, dynamic> block) {
    Map<String, dynamic> protocolState = block == null ? null : block['protocolState'];
    Map<String, dynamic> blockchainState = protocolState == null ? null : protocolState['blockchainState'];
    String dateTime = blockchainState == null ? null : blockchainState['date'];
    Map<String, dynamic> consensusState = protocolState == null ? null : protocolState['consensusState'];
    String blockHeight = consensusState == null ? 0 : consensusState['blockHeight'];

    Map<String, dynamic> transactions = block == null ? null : block['transactions'];

    if(null == transactions || null == transactions['userCommands']) return;

    List<dynamic> userCommands = transactions['userCommands'];
    if(userCommands.length == 0) return;

    for(int i = 0; i < userCommands.length; i++) {
      Map<String, dynamic> userCommand = userCommands[i];

      String sender = userCommand == null ? null : userCommand['from'];
      String receiver = userCommand == null ? null : userCommand['to'];

      if(publicKey == sender || publicKey == receiver) {
        MergedUserCommand mergedUserCommand = MergedUserCommand();
        mergedUserCommand.blockHeight = int.tryParse(blockHeight) ?? 0;
        mergedUserCommand.dateTime = dateTime;
        mergedUserCommand.hash = userCommand == null ? null : userCommand['hash'];
        mergedUserCommand.memo = userCommand == null ? null : userCommand['memo'];
        mergedUserCommand.fee = userCommand == null ? null : userCommand['fee'];
        mergedUserCommand.amount = userCommand == null ? null : userCommand['amount'];
        mergedUserCommand.nonce = userCommand == null ? null : userCommand['nonce'];
        mergedUserCommand.isDelegation = userCommand == null ? null : userCommand['isDelegation'];
        mergedUserCommand.from = sender;
        mergedUserCommand.to = receiver;
        mergedUserCommand.isPooled = false;
        mergedUserCommand.isIndexerMemo = false;
        mergedUserCommands.add(mergedUserCommand);
      }
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

      Map<String, dynamic> pooledUserCommand = pooledUserCommands[i];
      // TODO: Here maybe a bug in graphql server,
      // the filter will return some item not related to the publicKey, need to confirm with Mina Team
      if(pooledUserCommand['to'] != publicKey && pooledUserCommand['from'] != publicKey) {
        continue;
      }
      MergedUserCommand mergedUserCommand = MergedUserCommand();
      mergedUserCommand.to = pooledUserCommand['to'];
      mergedUserCommand.isDelegation = pooledUserCommand['isDelegation'];
      mergedUserCommand.nonce = pooledUserCommand['nonce'];
      mergedUserCommand.amount = pooledUserCommand['amount'];
      mergedUserCommand.fee = pooledUserCommand['fee'];
      mergedUserCommand.from = pooledUserCommand['from'];
      mergedUserCommand.hash = pooledUserCommand['hash'];
      mergedUserCommand.memo = pooledUserCommand['memo'];
      mergedUserCommand.isPooled = true;
      mergedUserCommand.dateTime = '';
      mergedUserCommand.blockHeight = 0;
      mergedUserCommand.isIndexerMemo = false;
      mergedUserCommands.add(mergedUserCommand);
    }
  }

  _mergeUserCommandsFromArchiveNode(List<IndexerTxnEntity> transactions) {
    if(null == transactions || 0 == transactions.length) {
      return;
    }

    transactions.forEach((transaction) {
      MergedUserCommand mergedUserCommand = MergedUserCommand();
      mergedUserCommand.to                = transaction?.receiver;
      mergedUserCommand.isDelegation      = (transaction?.type) == 'delegation';
      mergedUserCommand.nonce             = transaction?.nonce;
      mergedUserCommand.amount            = transaction?.amount;
      mergedUserCommand.fee               = transaction?.fee;
      mergedUserCommand.from              = transaction?.sender;
      mergedUserCommand.hash              = transaction?.hash;
      mergedUserCommand.memo              = transaction?.memo ?? '';
      mergedUserCommand.isPooled          = false;
      mergedUserCommand.blockHeight       = transaction?.blockHeight;
      mergedUserCommand.isIndexerMemo     = true;
      DateTime dateTime                   = DateTime.tryParse(transaction?.time);
      mergedUserCommand.dateTime          = (dateTime == null ? '' : dateTime.millisecondsSinceEpoch.toString());
      mergedUserCommands.add(mergedUserCommand);
    });
  }
}

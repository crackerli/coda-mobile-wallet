import 'dart:collection';

import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/service/indexer_service.dart';
import 'package:coda_wallet/txns/blocs/txns_events.dart';
import 'package:coda_wallet/txns/blocs/txns_states.dart';
import 'package:coda_wallet/txns/query/confirmed_txns_query.dart';
import 'package:coda_wallet/util/safe_map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/coda_service.dart';
import 'indexer_txns_entity.dart';
import 'txns_entity.dart';

class TxnsBloc extends Bloc<TxnsEvents, TxnsStates> {
  late CodaService _service;
  late IndexerService _indexerService;
  bool isTxnsLoading = false;
  // User commands merged from both pool and archive
  late List<MergedUserCommand> mergedUserCommands;
  int accountIndex = 0;
  int currentFilter = 0;
  List<String> txnFilters = ['ALL', 'SENT', 'RECEIVED', 'STAKED', 'CANCEL'];

  get filteredUserCommands {
    List<MergedUserCommand> commands = [];
    if(mergedUserCommands == null || mergedUserCommands.length == 0) {
      return commands;
    }

    // Get sent filtered list
    if(currentFilter == 1) {
      for(int i = 0; i < mergedUserCommands.length; i++) {
        if(!mergedUserCommands[i].isDelegation! && mergedUserCommands[i].from == publicKey) {
          commands.add(mergedUserCommands[i]);
        }
      }
      return commands;
    }

    // Get received filtered list
    if(currentFilter == 2) {
      for(int i = 0; i < mergedUserCommands.length; i++) {
        if(!mergedUserCommands[i].isDelegation! && mergedUserCommands[i].to == publicKey) {
          commands.add(mergedUserCommands[i]);
        }
      }
      return commands;
    }

    // Get staked filtered list
    if(currentFilter == 3) {
      for(int i = 0; i < mergedUserCommands.length; i++) {
        if(mergedUserCommands[i].isDelegation!) {
          commands.add(mergedUserCommands[i]);
        }
      }
      return commands;
    }

    // Default return all list
    return mergedUserCommands;
  }

  get publicKey => globalHDAccounts.accounts[accountIndex]!.address;

  TxnsBloc(TxnsStates state) : super(state) {
    _service = CodaService();
    _indexerService = IndexerService();
    isTxnsLoading = false;
    mergedUserCommands = [];
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
        String? error = result.statusMessage;
        yield RefreshConfirmedTxnsFail(error);
        return;
      }

      List<dynamic>? data = result.data;

      List<IndexerTxnEntity> transactions = [];

      if(null != data && data.length > 0) {
        data.forEach((element) {
          transactions.add(IndexerTxnEntity.fromMap(element)!);
        });
      }
      _mergeUserCommandsFromArchiveNode(transactions);

      // Sometimes we may see the same user commands in both archive node and best chain,
      // So need to remove the duplicated items.
      if(null != mergedUserCommands && mergedUserCommands.length > 0) {
        List<MergedUserCommand> temp = LinkedHashSet<MergedUserCommand>.from(
            mergedUserCommands).toList();
        mergedUserCommands.clear();
        mergedUserCommands.addAll(temp);
      }
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
      final result = await _service.performQuery(query, variables: variables!);

      if(result.hasException) {
        String error = exceptionHandle(result);
        yield RefreshPooledTxnsFail(error);
        return;
      }

      if(null == result.data) {
        yield RefreshPooledTxnsFail('No data found!');
        return;
      }

      mergedUserCommands.clear();
      List<dynamic> pooledUserCommands = result.data!['pooledUserCommands'] as List<dynamic>;
      _mergeUserCommandsFromPool(pooledUserCommands);
      // Figment's indexer server is one or more blocks height behind the latest,
      // so we need to read the latest block from best chain.
      List<dynamic>? bestChain = result.data!['bestChain'];
      if(null != bestChain && bestChain.length > 1) {
        // We get only the latest two blocks.
        _parseUserCommandsFromBestChain(bestChain[1]);
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
  _parseUserCommandsFromBestChain(Map<String, dynamic>? block) {
    if(null == block) {
      return;
    }

    SafeMap safeBlock = SafeMap(block);
    List<dynamic>? userCommands = safeBlock['transactions']['userCommands'].value;
    if(null == userCommands || userCommands.length == 0) return;

    userCommands.forEach((userCommand) {
      SafeMap safeUserCommand = SafeMap(userCommand);
      String sender = safeUserCommand['from'].value ?? '';
      String receiver = safeUserCommand['to'].value ?? '';

      if(publicKey == sender || publicKey == receiver) {
        MergedUserCommand mergedUserCommand = MergedUserCommand();
        mergedUserCommand.blockHeight       = int.tryParse(safeBlock['protocolState']['consensusState']['blockHeight'].value) ?? 0;
        print('In Best Chain, block height is: ${mergedUserCommand.blockHeight}');
        mergedUserCommand.dateTime          = safeBlock['protocolState']['blockchainState']['date'].value ?? '';
        mergedUserCommand.hash              = safeUserCommand['hash'].value;
        mergedUserCommand.memo              = safeUserCommand['memo'].value;
        mergedUserCommand.fee               = safeUserCommand['fee'].value;
        mergedUserCommand.amount            = safeUserCommand['amount'].value;
        mergedUserCommand.nonce             = safeUserCommand['nonce'].value;
        mergedUserCommand.isDelegation      = safeUserCommand['isDelegation'].value;
        mergedUserCommand.from              = sender;
        mergedUserCommand.to                = receiver;
        mergedUserCommand.isPooled          = false;
        mergedUserCommand.isIndexerMemo     = false;
        mergedUserCommands.add(mergedUserCommand);
      }
    });
  }

  _mergeUserCommandsFromPool(List<dynamic>? pooledUserCommands) {
    if(null == pooledUserCommands || 0 == pooledUserCommands.length) {
      return;
    }

    pooledUserCommands.forEach((pooledUserCommand) {
      SafeMap safeUserCommand = SafeMap(pooledUserCommand);
      // TODO: Here maybe a bug in graphql server,
      // the filter will return some item not related to the publicKey, need to confirm with Mina Team
      if(pooledUserCommand['to'] == publicKey || pooledUserCommand['from'] == publicKey) {
        MergedUserCommand mergedUserCommand = MergedUserCommand();
        mergedUserCommand.to                = safeUserCommand['to'].value           ?? '';
        mergedUserCommand.isDelegation      = safeUserCommand['isDelegation'].value ?? false;
        mergedUserCommand.nonce             = safeUserCommand['nonce'].value        ?? 0;
        mergedUserCommand.amount            = safeUserCommand['amount'].value       ?? '';
        mergedUserCommand.fee               = safeUserCommand['fee'].value          ?? '';
        mergedUserCommand.from              = safeUserCommand['from'].value         ?? '';
        mergedUserCommand.hash              = safeUserCommand['hash'].value         ?? '';
        mergedUserCommand.memo              = safeUserCommand['memo'].value         ?? '';
        mergedUserCommand.isPooled          = true;
        mergedUserCommand.dateTime          = '';
        mergedUserCommand.blockHeight       = 0;
        mergedUserCommand.isIndexerMemo     = false;
        mergedUserCommands.add(mergedUserCommand);
      }
    });
  }

  _mergeUserCommandsFromArchiveNode(List<IndexerTxnEntity?>? userCommands) {
    if(null == userCommands || 0 == userCommands.length) {
      return;
    }

    userCommands.forEach((transaction) {
      MergedUserCommand mergedUserCommand = MergedUserCommand();
      mergedUserCommand.to                = transaction?.receiver    ?? '';
      mergedUserCommand.nonce             = transaction?.nonce       ?? 0;
      mergedUserCommand.amount            = transaction?.amount      ?? '';
      mergedUserCommand.fee               = transaction?.fee         ?? '';
      mergedUserCommand.from              = transaction?.sender      ?? '';
      mergedUserCommand.hash              = transaction?.hash        ?? '';
      mergedUserCommand.memo              = transaction?.memo        ?? '';
      mergedUserCommand.blockHeight       = transaction?.blockHeight ?? 0;
      mergedUserCommand.isDelegation      = (transaction?.type) == 'delegation';
      mergedUserCommand.isPooled          = false;
      mergedUserCommand.isIndexerMemo     = true;
      DateTime? dateTime                   = DateTime.tryParse(transaction?.time ?? '');
      mergedUserCommand.dateTime          = (dateTime == null ? '' : dateTime.millisecondsSinceEpoch.toString());
      mergedUserCommands.add(mergedUserCommand);
    });
  }
}

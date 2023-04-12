// The transaction list composed by three parts.
// 1. Historic transactions get from figment archive node.
// 2. Pooled user commands get from figment graphql endpoint.
// 3. Because archive node is always one block behind the highest block height,
//   so we must get the recently included transaction from the best chain, which means we must
//   also call the graphql endpoint to find the recently one block to find if users' transaction is there.

import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/txns/blocs/txns_events.dart';
import 'package:coda_wallet/txns/blocs/txns_states.dart';
import 'package:coda_wallet/util/safe_map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/archive_service.dart';
import '../../service/coda_service.dart';
import '../constant/txns_filter_constant.dart';
import '../query/archived_txns_query.dart';
import 'txns_entity.dart';

class TxnsBloc extends Bloc<TxnsEvents, TxnsStates> {

  late CodaService _service;
  late ArchiveService _archiveService;
  bool isTxnsLoading = false;
  // User commands merged from both pool and archive
  List<MergedUserCommand> mergedUserCommands = [];
  int accountIndex = 0;
  TxnFilter currentFilter = TxnFilter.ALL;
  List<String> txnFilters = ['NO FILTERS', 'SENT FILTER', 'RECEIVED FILTER', 'STAKED FILTER', 'CANCEL'];

  get filteredUserCommands {
    if(mergedUserCommands.isEmpty) {
      return mergedUserCommands;
    }

    switch(currentFilter) {
      case TxnFilter.SENT:
        return mergedUserCommands.where((command) {
          return !command.isDelegation! && command.from == publicKey;
        }).toList();
      case TxnFilter.RECEIVED:
        return mergedUserCommands.where((command) {
          return !command.isDelegation! && command.to == publicKey;
        }).toList();
      case TxnFilter.STAKED:
        return mergedUserCommands.where((command) {
          return command.isDelegation!;
        }).toList();
      default:
        return mergedUserCommands;
    }
  }

  get publicKey => globalHDAccounts.accounts![accountIndex]!.address;

  TxnsBloc(TxnsStates state) : super(state) {
    _service = CodaService();
    _archiveService = ArchiveService();
    isTxnsLoading = false;
  }

  TxnsStates get initState => RefreshTxnsLoading([]);

  @override
  Stream<TxnsStates> mapEventToState(TxnsEvents event) async* {

    if(event is RefreshTxns) {
      yield* _mapRefreshTxnsToStates(event);
      return;
    }

    if(event is ChangeFilter) {
      yield* _mapChangeFilterToStates(event);
      return;
    }
  }

  Stream<TxnsStates>
    _mapChangeFilterToStates(ChangeFilter event) async* {
    yield FilterChanged(filteredUserCommands);
    return;
  }

  Stream<TxnsStates>
    _mapRefreshTxnsToStates(RefreshTxns event) async* {

    final query = event.query;
    final variables = event.variables ?? null;
    print('Start to get transactions history');

    try {
      isTxnsLoading = true;
      yield RefreshTxnsLoading(mergedUserCommands);
      final result = await _service.performQuery(query, variables: variables!);

      if(result.hasException) {
        String error = exceptionHandle(result);
        isTxnsLoading = false;
        yield RefreshTxnsFail(error);
        return;
      }

      print('get pooled transactions done');
      mergedUserCommands.clear();
      List<dynamic> pooledUserCommands = result.data!['pooledUserCommands'] as List<dynamic>;
      _mergeUserCommandsFromPool(pooledUserCommands);
      // Archive node server may one or more blocks height behind the latest,
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
        final result = await _archiveService.performQuery(ARCHIVED_TXNS_QUERY, variables: variables!);

        if(result.hasException) {
          String error = exceptionHandle(result);
          isTxnsLoading = false;
          yield RefreshTxnsFail(error);
          return;
        }
        print('get archived transactions done');
        List<dynamic>? data = result.data?['transactions'];

        _mergeUserCommandsFromArchiveNode(data);

        // Sometimes we may see the same user commands in both archive node and best chain,
        // So need to remove the duplicated items.
        if(mergedUserCommands.isNotEmpty) {
          final tempSet = Set();
          mergedUserCommands.retainWhere((command) => tempSet.add(command.hash));
        }

        yield RefreshTxnsSuccess(mergedUserCommands);
      }
      isTxnsLoading = false;
    } catch (e) {
      print('Error when get transaction list: $e');
      yield RefreshTxnsFail(e.toString());
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
        mergedUserCommand.failureReason     = safeUserCommand['failureReason'].value;
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
      /// TODO: Here maybe a bug in graphql server,
      /// the filter will return some item not related to the publicKey, need to confirm with Mina Team
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
        mergedUserCommand.failureReason     = safeUserCommand['failureReason'].value;
        mergedUserCommands.add(mergedUserCommand);
      }
    });
  }

  _mergeUserCommandsFromArchiveNode(List<dynamic>? transactions) {
    if(null == transactions || transactions.isEmpty) {
      return;
    }

    transactions.forEach((transaction) {
      MergedUserCommand mergedUserCommand = MergedUserCommand();
      mergedUserCommand.to           = transaction['to'];
      mergedUserCommand.isDelegation = transaction['isDelegation'];
      mergedUserCommand.nonce        = transaction['nonce'];
      /// TODO: Graphql deduced amount and fee's type to be int, this is not safe to
      /// handle a bigint, need to confirmed with graphql community to fix this.
      mergedUserCommand.amount       = transaction['amount'].toString();
      mergedUserCommand.fee          = transaction['fee'].toString();
      mergedUserCommand.from         = transaction['from'];
      mergedUserCommand.hash         = transaction['hash'];
      mergedUserCommand.memo         = transaction['memo'];
      mergedUserCommand.blockHeight  = transaction['blockHeight'];
      mergedUserCommand.isPooled     = false;
      mergedUserCommand.isIndexerMemo= false;
      mergedUserCommand.failureReason= transaction['failureReason'];
      mergedUserCommand.dateTime     =
          DateTime.tryParse(transaction['dateTime'])?.millisecondsSinceEpoch.toString();
      mergedUserCommands.add(mergedUserCommand);
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/service/mina_explorer_service.dart';
import 'package:coda_wallet/stake_pool_rank/blocs/stake_pool_rank_events.dart';
import 'package:coda_wallet/stake_pool_rank/blocs/stake_pool_rank_states.dart';
import 'package:coda_wallet/stake_pool_rank/query/get_validator_blocks.dart';
import 'block_produced_entity.dart';

class StakePoolRankBloc extends Bloc<StakePoolRankEvents, StakePoolRankStates> {
  late MinaExplorerService _minaExplorerService;
  late String creator;
  int minEpoch = 11;

  StakePoolRankBloc(StakePoolRankStates? state) : super(state!) {
    _minaExplorerService = MinaExplorerService();
  }

  StakePoolRankStates get initState => GetPoolBlocksLoading();

  @override
  Stream<StakePoolRankStates> mapEventToState(StakePoolRankEvents event) async* {
    if(event is GetPoolBlocks) {
      yield* _mapGetPoolBlocks(event);
      return;
    }
  }

  Stream<StakePoolRankStates>
   _mapGetPoolBlocks(GetPoolBlocks event) async* {

    final query = GET_POOL_BLOCKS;
    Map<String, dynamic> variables = Map<String, dynamic>();
    variables['creator'] = creator;
    variables['minEpoch'] = 11;

    try {
      yield GetPoolBlocksLoading();
      final result = await _minaExplorerService.performQuery(query, variables: variables);

      if(result.hasException) {
        String error = exceptionHandle(result);
        yield GetPoolBlocksFail(error);
        return;
      }

      if(null == result.data) {
        yield GetPoolBlocksFail('Get Pool Blocks failed!');
        return;
      }

      BlockProducedEntity? blockProducedEntity = BlockProducedEntity.fromMap(result.data);
      if(null == blockProducedEntity) {
        yield GetPoolBlocksFail('Get Pool Blocks failed!');
        return;
      }

      List<EpochBlocks> canonicalBlocks = [
        EpochBlocks(12, []),
        EpochBlocks(13, []),
        EpochBlocks(14, []),
        EpochBlocks(15, []),
      ];
      List<EpochBlocks> orphanBlocks = [
        EpochBlocks(12, []),
        EpochBlocks(13, []),
        EpochBlocks(14, []),
        EpochBlocks(15, []),
      ];
      _sortBlocks(blockProducedEntity.blocks, canonicalBlocks, orphanBlocks);

      yield GetPoolBlocksSuccess(canonicalBlocks, orphanBlocks);
    } catch (e) {
      print('${e.toString()}');
      yield GetPoolBlocksFail('Network Error, Please check and try again!');
    } finally {

    }
  }

  _sortBlocks(List<dynamic>? blockList, List<EpochBlocks> canonicalBlocks, List<EpochBlocks> orphanBlocks) {
    if(null == blockList || blockList.length == 0) {
      return null;
    }

    for(int i = 0; i < blockList.length;) {
      BlocksBean filteredBlockBean = blockList[i];

      int firstBlockHeight = filteredBlockBean.blockHeight!;

      // Continue to find the blocks on same height
      int j = 0;
      for(j = i + 1; j < blockList.length; j++) {
        BlocksBean blocksBean = blockList[j];

        int blockHeight = blocksBean.blockHeight!;
        if(firstBlockHeight == blockHeight) {
          if(blocksBean.canonical!) {
            filteredBlockBean.canonical = true;
          }
        } else {
          break;
        }
      }

      i = j;

      int? epochCount = filteredBlockBean.protocolState?.consensusState?.epoch;

      int epochIndex = epochCount! - minEpoch - 1;

      if(filteredBlockBean.canonical!) {
        List<BlocksBean> epochBlocks = canonicalBlocks[epochIndex].blocks;
        epochBlocks.add(filteredBlockBean);
      } else {
        List<BlocksBean> epochBlocks = orphanBlocks[epochIndex].blocks;
        epochBlocks.add(filteredBlockBean);
      }
    }
  }
}
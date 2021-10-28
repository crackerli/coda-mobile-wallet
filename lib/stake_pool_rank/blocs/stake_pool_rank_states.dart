import 'block_produced_entity.dart';

abstract class StakePoolRankStates {
  StakePoolRankStates();

  List<Object>? get props => null;
}

class GetPoolBlocksLoading extends StakePoolRankStates {

  GetPoolBlocksLoading() : super();

  @override
  List<Object> get props => ['GetPoolBlocksLoading'];
}

class GetPoolBlocksFail extends StakePoolRankStates {
  final dynamic data;

  GetPoolBlocksFail(this.data) : super();

  @override
  List<Object> get props => ['GetPoolBlocksFailed'];
}

class GetPoolBlocksSuccess extends StakePoolRankStates {
  final List<EpochBlocks> canonicalBlocks;
  final List<EpochBlocks> orphanBlocks;

  GetPoolBlocksSuccess(this.canonicalBlocks, this.orphanBlocks) : super();

  @override
  List<Object> get props => ['GetPoolBlocksSuccess'];
}

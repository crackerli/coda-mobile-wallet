abstract class StakePoolRankEvents {
  StakePoolRankEvents();

  List<Object>? get props => null;
}

// Get the historical 4 epochs' blocks produced
class GetPoolBlocks extends StakePoolRankEvents {

  GetPoolBlocks() : super();

  @override
  List<Object> get props => ['GetPoolBlocks'];
}

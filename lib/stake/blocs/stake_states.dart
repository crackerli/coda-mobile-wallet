abstract class StakeStates {
  StakeStates() : super();

  @override
  List<Object> get props => null;
}

class GetConsensusStateLoading extends StakeStates {
  final dynamic data;

  GetConsensusStateLoading(this.data) : super();

  @override
  List<Object> get props => data;
}

class GetConsensusStateFailed extends StakeStates {
  final dynamic data;

  GetConsensusStateFailed(this.data) : super();

  @override
  List<Object> get props => data;
}

class GetConsensusStateSuccess extends StakeStates {
  final int epoch;
  final int slot;

  GetConsensusStateSuccess(this.epoch, this.slot) : super();

  @override
  List<Object> get props => [epoch, slot];
}
abstract class StakeEvents {
  StakeEvents();

  @override
  List<Object> get props => null;
}

class GetConsensusState extends StakeEvents {
  final String query;
  final Map<String, dynamic> variables;

  GetConsensusState(this.query, {this.variables}) : super();
}
abstract class TxnsEvents {
  TxnsEvents();

  @override
  List<Object>? get props => null;
}

class RefreshTxns extends TxnsEvents {
  final String query;
  final Map<String, dynamic>? variables;

  RefreshTxns(this.query, {this.variables}) : super();

  @override
  List<Object> get props => [query, variables ?? {}];
}

class ChangeFilter extends TxnsEvents {
  ChangeFilter();
}

class ChangeAccount extends TxnsEvents {
  ChangeAccount();
}


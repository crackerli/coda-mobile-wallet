abstract class TxnsEvents {
  TxnsEvents();

  @override
  List<Object>? get props => null;
}

class RefreshPooledTxns extends TxnsEvents {
  final String query;
  final Map<String, dynamic>? variables;

  RefreshPooledTxns(this.query, {this.variables}) : super();

  @override
  List<Object> get props => [query, variables ?? {}];
}

class RefreshConfirmedTxns extends TxnsEvents {
  final String query;
  final Map<String, dynamic>? variables;

  RefreshConfirmedTxns(this.query, {this.variables}) : super();

  @override
  List<Object> get props => [query, variables ?? {}];
}

class ChangeFilter extends TxnsEvents {
  ChangeFilter();
}

class ChangeAccount extends TxnsEvents {
  ChangeAccount();
}

// class MoreConfirmedTxns extends TxnsEvents {
//   final String query;
//   final Map<String, dynamic> variables;
//
//   MoreConfirmedTxns(this.query, {this.variables}) : super();
//
//   @override
//   List<Object> get props => [query, variables];
// }

abstract class TxnsStates {
  TxnsStates();

  @override
  List<Object>? get props => null;
}

class AccountChanged extends TxnsStates {
  AccountChanged();
}

class FilterChanged extends TxnsStates {
  final dynamic data;

  FilterChanged(this.data);

  @override
  List<Object> get props => data.data;
}

class RefreshTxnsLoading extends TxnsStates {
  final dynamic data;

  RefreshTxnsLoading(this.data) : super();

  @override
  List<Object> get props => data.data;
}

class RefreshTxnsSuccess extends TxnsStates {
  final dynamic data;

  RefreshTxnsSuccess(this.data) : super();

  @override
  List<Object> get props => data;
}

class RefreshTxnsFail extends TxnsStates {
  final dynamic error;

  RefreshTxnsFail(this.error) : super();

  @override
  List<Object> get props => error;
}



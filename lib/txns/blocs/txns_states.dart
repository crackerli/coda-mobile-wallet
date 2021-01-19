abstract class TxnsStates {
  TxnsStates();

  @override
  List<Object> get props => null;
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

class RefreshPooledTxnsLoading extends TxnsStates {
  final dynamic data;

  RefreshPooledTxnsLoading(this.data) : super();

  @override
  List<Object> get props => data.data;
}

class RefreshPooledTxnsSuccess extends TxnsStates {
  final dynamic data;

  RefreshPooledTxnsSuccess(this.data) : super();

  @override
  List<Object> get props => data;
}

class RefreshPooledTxnsFail extends TxnsStates {
  final dynamic error;

  RefreshPooledTxnsFail(this.error) : super();

  @override
  List<Object> get props => error;
}

class RefreshConfirmedTxnsLoading extends TxnsStates {
  final dynamic data;

  RefreshConfirmedTxnsLoading(this.data) : super();

  @override
  List<Object> get props => data.data;
}

class RefreshConfirmedTxnsSuccess extends TxnsStates {
  final dynamic data;

  RefreshConfirmedTxnsSuccess(this.data) : super();

  @override
  List<Object> get props => data;
}

class RefreshConfirmedTxnsFail extends TxnsStates {
  final dynamic error;

  RefreshConfirmedTxnsFail(this.error) : super();

  @override
  List<Object> get props => error;
}

// class MoreConfirmedTxnsLoading extends TxnsStates {
//   final dynamic data;
//
//   MoreConfirmedTxnsLoading(this.data) : super();
//
//   @override
//   List<Object> get props => data;
// }
//
// class MoreConfirmedTxnsSuccess extends TxnsStates {
//   final dynamic data;
//
//   MoreConfirmedTxnsSuccess(this.data) : super();
//
//   @override
//   List<Object> get props => data;
// }
//
// class MoreConfirmedTxnsFail extends TxnsStates {
//   final dynamic error;
//
//   MoreConfirmedTxnsFail(this.error) : super();
//
//   @override
//   List<Object> get props => error;
// }

import 'package:equatable/equatable.dart';

abstract class TxnsStates extends Equatable {
  TxnsStates();

  @override
  List<Object> get props => null;
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

class MoreTxnsLoading extends TxnsStates {
  final dynamic data;

  MoreTxnsLoading(this.data) : super();

  @override
  List<Object> get props => data;
}

class MoreTxnsSuccess extends TxnsStates {
  final dynamic data;

  MoreTxnsSuccess(this.data) : super();

  @override
  List<Object> get props => data;
}

class MoreTxnsFail extends TxnsStates {
  final dynamic error;

  MoreTxnsFail(this.error) : super();

  @override
  List<Object> get props => error;
}

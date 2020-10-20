import 'package:equatable/equatable.dart';

abstract class AccountTxnsStates extends Equatable {
  AccountTxnsStates();

  @override
  List<Object> get props => null;
}

class RefreshAccountTxnsLoading extends AccountTxnsStates {
  final dynamic data;

  RefreshAccountTxnsLoading(this.data) : super();

  // @override
  // List<Object> get props => data.data;
}

class RefreshAccountTxnsSuccess extends AccountTxnsStates {
  final dynamic data;

  RefreshAccountTxnsSuccess(this.data) : super();

  // @override
  // List<Object> get props => data;
}

class RefreshAccountTxnsFail extends AccountTxnsStates {
  final dynamic error;

  RefreshAccountTxnsFail(this.error) : super();

  // @override
  // List<Object> get props => error;
}

class MoreAccountTxnsLoading extends AccountTxnsStates {
  final dynamic data;

  MoreAccountTxnsLoading(this.data) : super();

  // @override
  // List<Object> get props => data;
}

class MoreAccountTxnsSuccess extends AccountTxnsStates {
  final dynamic data;

  MoreAccountTxnsSuccess(this.data) : super();

  // @override
  // List<Object> get props => data;
}

class MoreAccountTxnsFail extends AccountTxnsStates {
  final dynamic error;

  MoreAccountTxnsFail(this.error) : super();

  @override
  List<Object> get props => error;
}
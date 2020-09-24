import 'package:equatable/equatable.dart';

abstract class AccountTxnsStates extends Equatable {
  AccountTxnsStates();

  @override
  List<Object> get props => null;
}

class Loading extends AccountTxnsStates {
  Loading() : super();
}

class LoadDataSuccess extends AccountTxnsStates {
  final dynamic data;

  LoadDataSuccess(this.data) : super();

  @override
  List<Object> get props => data;
}

class LoadDataFail extends AccountTxnsStates {
  final dynamic error;

  LoadDataFail(this.error) : super();

  @override
  List<Object> get props => error;
}

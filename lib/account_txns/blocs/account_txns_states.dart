import 'package:equatable/equatable.dart';

abstract class AccountTxnsStates extends Equatable {
  AccountTxnsStates();

  @override
  List<Object> get props => null;
}

class FetchAccountTxnsLoading extends AccountTxnsStates {
  FetchAccountTxnsLoading() : super();
}

class FetchAccountTxnsSuccess extends AccountTxnsStates {
  final dynamic data;

  FetchAccountTxnsSuccess(this.data) : super();

  @override
  List<Object> get props => data;
}

class FetchAccountTxnsFail extends AccountTxnsStates {
  final dynamic error;

  FetchAccountTxnsFail(this.error) : super();

  @override
  List<Object> get props => error;
}

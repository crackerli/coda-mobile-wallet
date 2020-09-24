import 'package:equatable/equatable.dart';

abstract class OwnedAccountsStates extends Equatable {
  OwnedAccountsStates();

  @override
  List<Object> get props => null;
}

class Loading extends OwnedAccountsStates {
  Loading() : super();
}

class LoadDataSuccess extends OwnedAccountsStates {
  final dynamic data;

  LoadDataSuccess(this.data) : super();

  @override
  List<Object> get props => data;
}

class LoadDataFail extends OwnedAccountsStates {
  final dynamic error;

  LoadDataFail(this.error) : super();

  @override
  List<Object> get props => error;
}

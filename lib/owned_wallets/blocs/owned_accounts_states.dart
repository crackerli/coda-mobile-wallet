import 'package:equatable/equatable.dart';

abstract class OwnedAccountsStates extends Equatable {
  OwnedAccountsStates();

  @override
  List<Object> get props => null;
}

class FetchOwnedAccountsLoading extends OwnedAccountsStates {
  FetchOwnedAccountsLoading() : super();
}

class FetchOwnedAccountsSuccess extends OwnedAccountsStates {
  final dynamic data;

  FetchOwnedAccountsSuccess(this.data) : super();

  @override
  List<Object> get props => data;
}

class FetchOwnedAccountsFail extends OwnedAccountsStates {
  final dynamic error;

  FetchOwnedAccountsFail(this.error) : super();

  @override
  List<Object> get props => error;
}

class LockAccountLoading extends OwnedAccountsStates {
  LockAccountLoading() : super();
}

class LockAccountSuccess extends OwnedAccountsStates {
  final dynamic data;

  LockAccountSuccess(this.data) : super();

  @override
  List<Object> get props => data;
}

class LockAccountFail extends OwnedAccountsStates {
  final dynamic error;

  LockAccountFail(this.error) : super();

  @override
  List<Object> get props => error;
}
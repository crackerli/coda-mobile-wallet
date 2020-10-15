import 'package:equatable/equatable.dart';

abstract class OwnedAccountsStates extends Equatable {
  OwnedAccountsStates();

  @override
  List<Object> get props => null;
}

class FetchOwnedAccountsLoading extends OwnedAccountsStates {
  final dynamic data;

  FetchOwnedAccountsLoading(this.data) : super();

  @override
  List<Object> get props => data;
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

class ToggleLockStatusLoading extends OwnedAccountsStates {
  ToggleLockStatusLoading() : super();
}

class ToggleLockStatusSuccess extends OwnedAccountsStates {
  final dynamic data;

  ToggleLockStatusSuccess(this.data) : super();

  @override
  List<Object> get props => data;
}

class ToggleLockStatusFail extends OwnedAccountsStates {
  final dynamic error;

  ToggleLockStatusFail(this.error) : super();

  @override
  List<Object> get props => error;
}

class CreateAccountLoading extends OwnedAccountsStates {
  CreateAccountLoading() : super();
}

class CreateAccountSuccess extends OwnedAccountsStates {
  final dynamic data;

  CreateAccountSuccess(this.data) : super();

  @override
  List<Object> get props => data;
}

class CreateAccountFail extends OwnedAccountsStates {
  final dynamic error;

  CreateAccountFail(this.error) : super();

  @override
  List<Object> get props => error;
}
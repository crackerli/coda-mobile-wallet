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
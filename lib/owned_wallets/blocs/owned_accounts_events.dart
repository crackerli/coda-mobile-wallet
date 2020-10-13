import 'package:equatable/equatable.dart';

abstract class OwnedAccountsEvents extends Equatable {
  OwnedAccountsEvents();

  @override
  List<Object> get props => null;
}

class FetchOwnedAccounts extends OwnedAccountsEvents {
  final String query;
  final Map<String, dynamic> variables;

  FetchOwnedAccounts(this.query, {this.variables}) : super();

  @override
  List<Object> get props => [query, variables];
}

class ToggleLockStatus extends OwnedAccountsEvents {
  final String mutation;
  final Map<String, dynamic> variables;

  ToggleLockStatus(this.mutation, {this.variables}) : super();

  @override
  List<Object> get props => [mutation, variables];
}

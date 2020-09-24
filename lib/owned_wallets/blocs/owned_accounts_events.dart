import 'package:equatable/equatable.dart';

abstract class OwnedAccountsEvents extends Equatable {
  OwnedAccountsEvents();

  @override
  List<Object> get props => null;
}

class FetchOwnedAccountsData extends OwnedAccountsEvents {
  final String query;
  final Map<String, dynamic> variables;

  FetchOwnedAccountsData(this.query, {this.variables}) : super();

  @override
  List<Object> get props => [query, variables];
}

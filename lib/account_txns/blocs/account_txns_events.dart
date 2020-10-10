import 'package:equatable/equatable.dart';

abstract class AccountTxnsEvents extends Equatable {
  AccountTxnsEvents();

  @override
  List<Object> get props => null;
}

class RefreshAccountTxns extends AccountTxnsEvents {
  final String query;
  final Map<String, dynamic> variables;

  RefreshAccountTxns(this.query, {this.variables}) : super();

  @override
  List<Object> get props => [query, variables];
}

class MoreAccountTxns extends AccountTxnsEvents {
  final String query;
  final Map<String, dynamic> variables;

  MoreAccountTxns(this.query, {this.variables}) : super();

  @override
  List<Object> get props => [query, variables];
}
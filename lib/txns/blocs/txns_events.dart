import 'package:equatable/equatable.dart';

abstract class TxnsEvents extends Equatable {
  TxnsEvents();

  @override
  List<Object> get props => null;
}

class RefreshTxns extends TxnsEvents {
  final String query;
  final Map<String, dynamic> variables;

  RefreshTxns(this.query, {this.variables}) : super();

  @override
  List<Object> get props => [query, variables];
}

class MoreTxns extends TxnsEvents {
  final String query;
  final Map<String, dynamic> variables;

  MoreTxns(this.query, {this.variables}) : super();

  @override
  List<Object> get props => [query, variables];
}

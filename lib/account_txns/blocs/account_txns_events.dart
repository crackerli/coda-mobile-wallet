import 'package:equatable/equatable.dart';

abstract class AccountTxnsEvents extends Equatable {
  AccountTxnsEvents();

  @override
  List<Object> get props => null;
}

class FetchAccountTxnsData extends AccountTxnsEvents {
  final String query;
  final Map<String, dynamic> variables;

  FetchAccountTxnsData(this.query, {this.variables}) : super();

  @override
  List<Object> get props => [query, variables];
}

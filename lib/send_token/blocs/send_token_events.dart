import 'package:equatable/equatable.dart';

abstract class SendTokenEvents extends Equatable {
  SendTokenEvents();

  @override
  List<Object> get props => null;
}

class SendPayment extends SendTokenEvents {
  final String mutation;
  final Map<String, dynamic> variables;

  SendPayment(this.mutation, {this.variables}) : super();

  @override
  List<Object> get props => [mutation, variables];
}

class UnlockAccount extends SendTokenEvents {
  final String mutation;
  final Map<String, dynamic> variables;

  UnlockAccount(this.mutation, {this.variables}) : super();

  @override
  List<Object> get props => [mutation, variables];
}
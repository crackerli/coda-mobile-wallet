import 'package:equatable/equatable.dart';

abstract class SendTokenEvents extends Equatable {
  SendTokenEvents();

  @override
  List<Object> get props => null;
}

class ValidateInput extends SendTokenEvents {
  ValidateInput() : super();
}

class SendPayment extends SendTokenEvents {
  final String mutation;
  final Map<String, dynamic> variables;

  SendPayment(this.mutation, {this.variables}) : super();

  @override
  List<Object> get props => [mutation, variables];
}

class ToggleLockStatus extends SendTokenEvents {
  final String mutation;
  final Map<String, dynamic> variables;

  ToggleLockStatus(this.mutation, {this.variables}) : super();

  @override
  List<Object> get props => [mutation, variables];
}

// class GetNonce extends SendTokenEvents {
//   final String query;
//   final Map<String, dynamic> variables;
//
//   GetNonce(this.query, {this.variables}) : super();
//
//   @override
//   List<Object> get props => [query, variables];
// }
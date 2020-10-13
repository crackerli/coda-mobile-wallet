import 'package:equatable/equatable.dart';

abstract class SendTokenEvents extends Equatable {
  SendTokenEvents();

  @override
  List<Object> get props => null;
}

class SendToken extends SendTokenEvents {
  final String mutation;
  final Map<String, dynamic> variables;

  SendToken(this.mutation, {this.variables}) : super();

  @override
  List<Object> get props => [mutation, variables];
}
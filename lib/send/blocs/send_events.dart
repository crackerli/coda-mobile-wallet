import 'package:equatable/equatable.dart';

abstract class SendEvents/* extends Equatable*/ {
  SendEvents();

  @override
  List<Object> get props => null;
}

class FeeValidate extends SendEvents {
  FeeValidate() : super();
}

class Send extends SendEvents {
  final String mutation;
  final Map<String, dynamic> variables;

  Send(this.mutation, {this.variables}) : super();

  @override
  List<Object> get props => [mutation, variables];
}

class GetNonce extends SendEvents {
  final String query;
  final Map<String, dynamic> variables;

  GetNonce(this.query, {this.variables}) : super();

  @override
  List<Object> get props => [query, variables];
}

class GetPooledFee extends SendEvents {
  final String query;
  final Map<String, dynamic> variables;

  GetPooledFee(this.query, {this.variables}) : super();

  @override
  List<Object> get props => [query, variables];
}

class ChooseFee extends SendEvents {
  final int index;
  ChooseFee(this.index) : super();
}
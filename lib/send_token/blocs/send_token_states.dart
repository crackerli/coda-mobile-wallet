import 'package:equatable/equatable.dart';

abstract class SendTokenStates extends Equatable {
  SendTokenStates();

  @override
  List<Object> get props => null;
}

class SendPaymentLoading extends SendTokenStates {
  final dynamic data;

  SendPaymentLoading(this.data) : super();

  @override
  List<Object> get props => data;
}

class SendPaymentSuccess extends SendTokenStates {
  final dynamic data;

  SendPaymentSuccess(this.data) : super();

  @override
  List<Object> get props => data;
}

class SendPaymentFail extends SendTokenStates {
  final dynamic error;

  SendPaymentFail(this.error) : super();

  @override
  List<Object> get props => error;
}
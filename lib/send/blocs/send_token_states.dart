import 'package:equatable/equatable.dart';

abstract class SendTokenStates extends Equatable {
  SendTokenStates();

  @override
  List<Object> get props => null;
}

class InputValidated extends SendTokenStates {
  InputValidated() : super();
}

class InputInvalidated extends SendTokenStates {
  InputInvalidated() : super();
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

class ToggleLockStatusLoading extends SendTokenStates {
  ToggleLockStatusLoading() : super();
}

class ToggleLockStatusSuccess extends SendTokenStates {
  ToggleLockStatusSuccess() : super();
}

class ToggleLockStatusFail extends SendTokenStates {
  final dynamic error;

  ToggleLockStatusFail(this.error) : super();

  @override
  List<Object> get props => error;
}
//
// class GetNonceLoading extends SendTokenStates {
//   GetNonceLoading() : super();
// }
//
// class GetNonceSuccess extends SendTokenStates {
//   GetNonceSuccess() : super();
// }
//
// class GetNonceFail extends SendTokenStates {
//   final dynamic error;
//
//   GetNonceFail(this.error) : super();
//
//   @override
//   List<Object> get props => error;
// }
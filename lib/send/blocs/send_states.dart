import 'package:equatable/equatable.dart';

abstract class SendStates extends Equatable {
  SendStates();

  @override
  List<Object> get props => null;
}

class FeeValidated extends SendStates {
  FeeValidated() : super();
}

class FeeInvalidated extends SendStates {
  FeeInvalidated() : super();
}

class SendLoading extends SendStates {
  final dynamic data;

  SendLoading(this.data) : super();

  @override
  List<Object> get props => data;
}

class SendSuccess extends SendStates {
  final dynamic data;

  SendSuccess(this.data) : super();

  @override
  List<Object> get props => data;
}

class SendFail extends SendStates {
  final dynamic error;

  SendFail(this.error) : super();

  @override
  List<Object> get props => error;
}

class GetNonceLoading extends SendStates {
  GetNonceLoading() : super();
}

class GetNonceSuccess extends SendStates {
  GetNonceSuccess() : super();
}

class GetNonceFail extends SendStates {
  final dynamic error;

  GetNonceFail(this.error) : super();

  @override
  List<Object> get props => error;
}
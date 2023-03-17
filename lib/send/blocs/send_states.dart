abstract class SendStates {
  SendStates() : super();

  @override
  List<Object>? get props => null;
}

class SendPrepare extends SendStates {
  SendPrepare() : super();
}

class FeeValidated extends SendStates {
  FeeValidated() : super();
}

class FeeInvalidated extends SendStates {
  FeeInvalidated() : super();
}

class SendActionsLoading extends SendStates {
}

class SendActionsSuccess extends SendStates {

}

class SendActionsFail extends SendStates {
  final dynamic error;

  SendActionsFail(this.error) : super();

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

class GetPooledFeeLoading extends SendStates {
  GetPooledFeeLoading() : super();
}

class GetPooledFeeSuccess extends SendStates {
  final dynamic data;

  GetPooledFeeSuccess(this.data) : super();

  @override
  List<Object> get props => data;
}

class GetPooledFeeFail extends SendStates {
  final dynamic error;

  GetPooledFeeFail(this.error) : super();

  @override
  List<Object> get props => error;
}

class FeeChosen extends SendStates {
  final int index;

  FeeChosen(this.index) : super();
}

class DecryptSeedLoading extends SendStates {}

class DecryptSeedFail extends SendStates {}

class DecryptSeedSuccess extends SendStates {}

// Used for clear the decrypt failed state and forbid snack bar pop out repeatedly
class SeedPasswordCleared extends SendStates {
  SeedPasswordCleared() : super();
}

class UserCancelled extends SendStates {}
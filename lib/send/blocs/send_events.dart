abstract class SendEvents {
  SendEvents();

  @override
  List<Object>? get props => null;
}

// SendActions event include GetNonce, Send, and report to Everstake if needed
class SendActions extends SendEvents {}

class GetNonce extends SendEvents {
  final String query;
  final Map<String, dynamic>? variables;

  GetNonce(this.query, {this.variables}) : super();

  @override
  List<Object> get props => [query, variables ?? {}];
}

class GetPooledFee extends SendEvents {
  final String query;
  final Map<String, dynamic>? variables;

  GetPooledFee(this.query, {this.variables}) : super();

  @override
  List<Object> get props => [query, variables ?? {}];
}

class ChooseFee extends SendEvents {
  final int index;
  ChooseFee(this.index) : super();
}

class DecryptSeed extends SendEvents {
  final String password;

  DecryptSeed(this.password);
}

// Used for clear the decrypt failed state and forbid snack bar pop out repeatedly
class ClearWrongPassword extends SendEvents {
  ClearWrongPassword() : super();
}

class UserCancel extends SendEvents {}
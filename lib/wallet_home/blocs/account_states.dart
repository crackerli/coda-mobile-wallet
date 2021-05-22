abstract class AccountStates {
  AccountStates();

  @override
  List<Object>? get props => null;
}

class GetAccountsLoading extends AccountStates {

  GetAccountsLoading() : super();

  @override
  List<Object>? get props => null;
}

class GetAccountsSuccess extends AccountStates {
  final dynamic data;

  GetAccountsSuccess(this.data) : super();

  @override
  List<Object> get props => data.data;
}

class GetAccountsFail extends AccountStates {
  final dynamic data;

  GetAccountsFail(this.data) : super();

  @override
  List<Object> get props => data.data;
}

class GetAccountsFinished extends AccountStates {
  GetAccountsFinished() : super();

  @override
  List<Object>? get props => null;
}
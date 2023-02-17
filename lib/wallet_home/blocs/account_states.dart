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

  GetAccountsSuccess() : super();

  @override
  List<Object>? get props => null;
}

class GetAccountsFail extends AccountStates {

  GetAccountsFail() : super();

  @override
  List<Object>? get props => null;
}

class GetExchangeInfoLoading extends AccountStates {

  GetExchangeInfoLoading() : super();

  @override
  List<Object>? get props => null;
}

class GetExchangeInfoSuccess extends AccountStates {
  final dynamic data;

  GetExchangeInfoSuccess(this.data) : super();

  @override
  List<Object> get props => data.data;
}

class GetExchangeInfoFail extends AccountStates {
  final dynamic data;

  GetExchangeInfoFail(this.data) : super();

  @override
  List<Object> get props => data.data;
}

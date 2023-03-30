abstract class AccountEvents {
  AccountEvents();

  @override
  List<Object>? get props => null;
}

class GetAccounts extends AccountEvents {
  final bool getExchangeInfo;

  GetAccounts(this.getExchangeInfo) : super();

  @override
  List<Object>? get props => null;
}

class AccountEntity {
  late AccountData data;
}

class AccountData {
  Account? account;
}

class Account {
  String? nonce;
  bool? stakingActive;
  String? token;
  Balance? balance;
  DelegateAccount? delegateAccount;
}

class Balance {
  String? total;
}

class DelegateAccount {
  String? publicKey;
}
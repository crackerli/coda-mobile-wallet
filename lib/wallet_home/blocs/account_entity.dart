class AccountEntity {
  late AccountData data;
}

class AccountData {
  late Account account;
}

class Account {
  late String nonce;
  late bool stakingActive;
  late String token;
  late Balance balance;
  late DelegateAccount delegateAccount;
}

class Balance {
  late String total;
}

class DelegateAccount {
  late String publicKey;
}
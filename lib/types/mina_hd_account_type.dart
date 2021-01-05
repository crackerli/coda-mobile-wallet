class MinaHDAccount {
  int account;
  String address;
  String accountName;
  bool isDelegated;
  String pool;
  // handle the balance as nano mina
  String balance;

  MinaHDAccount({this.account, this.address, this.accountName, this.isDelegated, this.pool, this.balance});
}
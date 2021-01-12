
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';

String getWalletBalance() {
  double walletBalance = 0.0;
  for(int i = 0; i < testAccounts.length; i++) {
    double balance = double.parse(testAccounts[i].balance);
    walletBalance = balance + walletBalance;
  }
  return (walletBalance / 1000000000).toString();
}

String getWalletPrice() {
  double walletBalance = 0.0;
  for(int i = 0; i < testAccounts.length; i++) {
    double balance = double.parse(testAccounts[i].balance);
    walletBalance = balance + walletBalance;
  }
  double tmp = walletBalance / 1000000000;
  return (tmp * gUnitFiatPrice).toString();
}

List<MinaHDAccount> testAccounts = [
  MinaHDAccount(
    account: 0,
    address: 'B62qrPN5Y5yq8kGE3FbVKbGTdTAJNdtNtB5sNVpxyRwWGcDEhpMzc8g',
    accountName: 'Account#0',
    isDelegated: true,
    pool: 'Spark Pool',
    balance: '129876123456789'
  ),
  MinaHDAccount(
    account: 1,
    address: 'B62qkgfoZ8Nd4bbvstoSbebHcvPR4Z7kSLu3DANSuHdRifaFuLFsjam',
    accountName: 'Account#1',
    isDelegated: true,
    pool: 'Staking Power',
    balance: '9999999999987654321'
  ),
  MinaHDAccount(
    account: 2,
    address: 'B62qqvaMLuNbQPhXaz2PQAjKULyryC7fDtFbH7Q8vpD7LiwnA9botQq',
    accountName: 'Account#2',
    isDelegated: false,
    pool: '',
    balance: '1000000000'
  ),
];
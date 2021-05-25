import 'package:coda_wallet/global/global.dart';
import 'package:ffi_mina_signer/util/mina_helper.dart';

String getWalletBalance() {
  if(globalHDAccounts == null
    || globalHDAccounts.accounts == null
    || globalHDAccounts.accounts!.length == 0) {
    return '0';
  }

  BigInt walletBalance = BigInt.from(0);
  for(int i = 0; i < globalHDAccounts.accounts!.length; i++) {
    BigInt? balance = BigInt.tryParse(globalHDAccounts.accounts![i]!.balance!);
    if(null != balance) {
      walletBalance = balance + walletBalance;
    }
  }
  return MinaHelper.getMinaStrByNanoNum(walletBalance);
}

String getWalletPrice() {
  if(globalHDAccounts == null
    || globalHDAccounts.accounts == null
    || globalHDAccounts.accounts!.length == 0) {
    return '0';
  }
  double walletBalance = 0.0;
  for(int i = 0; i < globalHDAccounts.accounts!.length; i++) {
    double balance = double.parse(globalHDAccounts.accounts![i]!.balance!);
    walletBalance = balance + walletBalance;
  }
  double tmp = walletBalance / 1000000000;
  return (tmp * gUnitFiatPrice).toString();
}

class MinaHDAccount {
  List<AccountBean?>? accounts;

  static MinaHDAccount? fromMap(Map<String, dynamic>? map) {
    if (map == null) return MinaHDAccount();
    MinaHDAccount minaHDAccountBean = MinaHDAccount();
    minaHDAccountBean.accounts = []..addAll(
      (map['accounts'] as List).map((o) => AccountBean.fromMap(o))
    );
    return minaHDAccountBean;
  }

  Map toJson() => {
    "accounts": accounts,
  };
}

class AccountBean {
  int? account;
  String? accountName;
  String? address;
  // Deprecated
  bool? isDelegated;
  // Deprecated
  String? pool;
  // handle the balance as nano mina
  String? balance;
  bool? isActive;
  String? stakingAddress;

  static AccountBean? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    AccountBean accountsBean = AccountBean();
    accountsBean.account = map['account'];
    accountsBean.accountName = map['accountName'];
    accountsBean.address = map['address'];
    accountsBean.isDelegated = map['isDelegated'];
    accountsBean.pool = map['pool'];
    accountsBean.balance = map['balance'];
    accountsBean.isActive = map['isActive'];
    accountsBean.stakingAddress = map['stakingAddress'];
    return accountsBean;
  }

  Map toJson() => {
    "account": account,
    "accountName": accountName,
    "address": address,
    "isDelegated": isDelegated,
    "pool": pool,
    "balance": balance,
    "isActive": isActive,
    "stakingAddress": stakingAddress
  };
}
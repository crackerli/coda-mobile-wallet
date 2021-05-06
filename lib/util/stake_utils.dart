import 'package:coda_wallet/global/global.dart';

String getStakePercent() {
  if(null == globalHDAccounts || null == globalHDAccounts.accounts) {
    return '0.0';
  }

  BigInt staked = BigInt.from(0);
  BigInt total = BigInt.from(0);
  globalHDAccounts.accounts.forEach((account) {
    if(null != account && account.isActive) {
      BigInt accountBalance = BigInt.tryParse(account.balance) ?? BigInt.from(0);
      total += accountBalance;
      if(account.stakingAddress.isNotEmpty && account.stakingAddress != account.address) {
        staked += accountBalance;
      }
    }
  });

  if(staked == BigInt.from(0) || total == BigInt.from(0)) {
    return '0.0';
  }

  String percent = (staked / total).toStringAsFixed(3);

  return percent;
}
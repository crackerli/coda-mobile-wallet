import 'package:coda_wallet/global/global.dart';

String getStakePercent() {
  if(null == globalHDAccounts.accounts) {
    return '0.0';
  }

  BigInt staked = BigInt.from(0);
  BigInt total = BigInt.from(0);
  globalHDAccounts.accounts!.forEach((account) {
    if(null != account && account.isActive!) {
      BigInt accountBalance = BigInt.tryParse(account.balance!) ?? BigInt.from(0);
      total += accountBalance;
      if(null != account.stakingAddress && account.stakingAddress!.isNotEmpty && account.stakingAddress != account.address) {
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

bool walletStaking() {
  if(null == globalHDAccounts.accounts) {
    return false;
  }

  bool isStaking = false;
  globalHDAccounts.accounts!.forEach((account) {
    if(null != account && account.isActive!) {
      if(null != account.stakingAddress && account.stakingAddress!.isNotEmpty && account.stakingAddress != account.address) {
        isStaking = true;
      }
    }
  });

  return isStaking;
}
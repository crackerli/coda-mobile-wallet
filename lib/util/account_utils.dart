// MinaHDAccount(
// account: 0,
// address: 'B62qrPN5Y5yq8kGE3FbVKbGTdTAJNdtNtB5sNVpxyRwWGcDEhpMzc8g',
// accountName: 'Account#0',
// isDelegated: true,
// pool: 'Spark Pool',
// balance: '129876123456789'
// ),
import 'dart:typed_data';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:ffi_mina_signer/sdk/mina_signer_sdk.dart';
import 'package:ffi_mina_signer/util/mina_helper.dart';

Future<List<AccountBean>> deriveDefaultAccount(Uint8List seed) async {
  List<AccountBean> hdAccounts = [];

  for(int i = 0; i < DEFAULT_ACCOUNT_NUMBER; i++) {
    AccountBean account = AccountBean();
    account.account = i;
    account.accountName = 'Account #$i';
    account.balance = "0";
    account.pool = "";
    account.isDelegated = false;
    account.isActive = false;
    account.stakingAddress = '';
    Uint8List privateKey = generatePrivateKey(seed, i);
    String address = await getAddressFromSecretKeyAsync(MinaHelper.reverse(privateKey));
    account.address = address;
    hdAccounts.add(account);
  }
  return hdAccounts;
}

Future<AccountBean> deriveNewAccount(Uint8List seed, int accountIndex, String accountName) async {

  AccountBean account = AccountBean();
  account.account = accountIndex;
  account.accountName = accountName;
  account.balance = "0";
  account.pool = "";
  account.isDelegated = false;
  account.isActive = false;
  account.stakingAddress = '';
  Uint8List privateKey = generatePrivateKey(seed, accountIndex);
  String address = await getAddressFromSecretKeyAsync(MinaHelper.reverse(privateKey));
  account.address = address;

  return account;
}
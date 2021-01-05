
import 'package:coda_wallet/types/mina_hd_account_type.dart';

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
    address: 'B62qrPN5Y5yq8kGE3FbVKbGTdTAJNdtNtB5sNVpxyRwWGcDEhpMzc8g',
    accountName: 'Account#1',
    isDelegated: true,
    pool: 'Staking Power',
    balance: '9999999999987654321'
  ),
  MinaHDAccount(
    account: 2,
    address: 'B62qrPN5Y5yq8kGE3FbVKbGTdTAJNdtNtB5sNVpxyRwWGcDEhpMzc8g',
    accountName: 'Account#2',
    isDelegated: false,
    pool: '',
    balance: '1000000000'
  ),
];
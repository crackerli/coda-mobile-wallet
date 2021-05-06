import 'package:coda_wallet/my_accounts/screen/account_detail_screen.dart';
import 'package:coda_wallet/my_accounts/screen/create_account_screen.dart';
import 'package:coda_wallet/my_accounts/screen/edit_account_screen.dart';
import 'package:coda_wallet/my_accounts/screen/my_accounts_screen.dart';
import 'package:coda_wallet/new_user_onboard/screen/encrypt_seed_screen.dart';
import 'package:coda_wallet/new_user_onboard/screen/import_recovery_phrase_screen.dart';
import 'package:coda_wallet/new_user_onboard/screen/new_wallet_alert.dart';
import 'package:coda_wallet/new_user_onboard/screen/no_wallet_screen.dart';
import 'package:coda_wallet/new_user_onboard/screen/recovery_phrase_screen.dart';
import 'package:coda_wallet/new_user_onboard/screen/verify_recovery_phrase_screen.dart';
import 'package:coda_wallet/qr_scan/qr_scanner.dart';
import 'package:coda_wallet/receive/screen/receive_account_list.dart';
import 'package:coda_wallet/receive/screen/receive_account_screen.dart';
import 'package:coda_wallet/send/blocs/send_bloc.dart';
import 'package:coda_wallet/send/screens/send_amount_screen.dart';
import 'package:coda_wallet/send/screens/send_fee_screen.dart';
import 'package:coda_wallet/send/screens/send_from_screen.dart';
import 'package:coda_wallet/send/screens/send_to_screen.dart';
import 'package:coda_wallet/setting/network_setting_screen.dart';
import 'package:coda_wallet/stake/screen/account_no_stake_screen.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_bloc.dart';
import 'package:coda_wallet/stake_provider/screen/stake_providers_screen.dart';
import 'package:coda_wallet/txn_detail/screens/txn_detail_screen.dart';
import 'package:coda_wallet/txns/screen/txns_choose_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const SendFromRoute = '/SendFromScreen';
const SendToRoute = '/SendToScreen';
const SendAmountRoute = '/SendAmountScreen';
const SendFeeRoute = '/SendFeeScreen';
const QrScanRoute = '/QrScanScreen';
const TxnDetailRoute = '/TxnDetailScreen';
const ReceiveAccountsRoute = '/ReceiveAccountsScreen';
const ReceiveAccountRoute = '/ReceiveAccountScreen';
const RecoveryPhraseRoute = '/RecoveryPhraseScreen';
const NoWalletRoute = '/NoWalletScreen';
const VerifyRecoveryPhraseRoute = '/VerifyRecoveryPhraseScreen';
const ImportRecoveryPhraseRoute = '/ImportRecoveryPhraseScreen';
const TxnsChooseAccountRoute = '/TxnsChooseAccountScreen';
const MyAccountsRoute = '/MyAccountsScreen';
const AccountDetailRoute = '/AccountDetailScreen';
const CreateAccountRoute = '/CreateAccountScreen';
const EditAccountRoute = '/EditAccountScreen';
const EncryptSeedRoute = '/EncryptSeedScreen';
const NewWalletAlertRoute = '/NewWalletAlertScreen';
const NetworkSettingRoute = '/NetworkSettingScreen';
const StakeProviderRoute = '/StakeProviderScreen';
const AccountNoStakeRoute = '/AccountNoStakeScreen';

var globalRoutes = {
  '$SendFromRoute': (context) => SendFromScreen(),
  '$SendToRoute': (context) => SendToScreen(),
  '$SendFeeRoute': (context) => BlocProvider<SendBloc>(
    create: (BuildContext context) {
      return SendBloc(null);
    },
    child: SendFeeScreen()
  ),
  '$SendAmountRoute': (context) => SendAmountScreen(),
  '$QrScanRoute': (context) => QrScanScreen(),
  '$TxnDetailRoute': (context) => TxnDetailScreen(),
  '$ReceiveAccountRoute': (context) => ReceiveAccountScreen(),
  '$ReceiveAccountsRoute': (context) => ReceiveAccountsScreen(),
  '$RecoveryPhraseRoute': (context) => RecoveryPhraseScreen(),
  '$NoWalletRoute': (context) => NoWalletScreen(),
  '$VerifyRecoveryPhraseRoute': (context) => VerifyRecoveryPhraseScreen(),
  '$ImportRecoveryPhraseRoute': (context) => ImportRecoveryPhraseScreen(),
  '$TxnsChooseAccountRoute': (context) => TxnsChooseAccountScreen(),
  '$MyAccountsRoute': (context) => MyAccountsScreen(),
  '$AccountDetailRoute': (context) => AccountDetailScreen(),
  '$CreateAccountRoute': (context) => CreateAccountScreen(),
  '$EditAccountRoute': (context) => EditAccountScreen(),
  '$EncryptSeedRoute': (context) => EncryptSeedScreen(),
  '$NewWalletAlertRoute': (context) => NewWalletAlertScreen(),
  '$NetworkSettingRoute': (context) => NetworkSettingScreen(),
  '$StakeProviderRoute': (context) => BlocProvider<StakeProvidersBloc>(
    create: (BuildContext context) {
      return StakeProvidersBloc(null);
    },
    child: StakeProviderScreen()
  ),
  '$AccountNoStakeRoute': (context) => AccountNoStakeScreen(),
};
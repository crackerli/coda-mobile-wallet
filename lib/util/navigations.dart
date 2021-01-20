import 'package:coda_wallet/qr_address/qr_address_screen.dart';
import 'package:coda_wallet/qr_scan/qr_scanner.dart';
import 'package:coda_wallet/route/routes.dart';
//import 'package:coda_wallet/send/screens/send_token_screen.dart';
import 'package:coda_wallet/setting/network_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//toAccountTxnsScreen(BuildContext context, Account account) {
//
//   Navigator.push(context,
//     MaterialPageRoute(builder: (context) {
//       return BlocProvider<AccountTxnsBloc>(
//         create: (BuildContext context) {
//           return AccountTxnsBloc(RefreshAccountTxnsLoading(null), account.publicKey);
//         },
//         child: AccountTxnsScreen(account)
//       );
//     }
//   ));
// }

toQrAddressScreen(BuildContext context, String publicKey) {
  Navigator.push(context,
    MaterialPageRoute(builder: (context) => QrAddress(publicKey))
  );
}

// toSendTokenScreen(BuildContext context, String publicKey, String balance, bool locked, bool isDelegation) {
//   Navigator.push(context,
//     MaterialPageRoute(builder: (context) {
//       return BlocProvider<SendTokenBloc>(
//         create: (BuildContext context) {
//           return SendTokenBloc(InputInvalidated());
//         },
//         child: SendTokenScreen(publicKey, balance, locked, isDelegation)
//       );
//     }
//   ));
// }

dynamic toQrScanScreen(BuildContext context) async {
  final result = Navigator.pushNamed(context, QrScanRoute);
  return result;
}

dynamic toSettingScreen(BuildContext context) async {
  final result = Navigator.push(context,
    MaterialPageRoute(builder: (context) => NetworkSettingScreen())
  );
  return result;
}

// toTxnDetailScreen(BuildContext context, MergedUserCommand mergedUserCommand, String publicKey) {
//   Navigator.push(context,
//     MaterialPageRoute(builder: (context) => TxnDetailScreen(publicKey: publicKey, mergedUserCommand: mergedUserCommand))
//   );
// }
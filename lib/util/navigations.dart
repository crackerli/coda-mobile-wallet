import 'package:coda_wallet/qr_address/qr_address_screen.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/setting/network_setting_screen.dart';
import 'package:flutter/material.dart';

toQrAddressScreen(BuildContext context, String publicKey) {
  Navigator.push(context,
    MaterialPageRoute(builder: (context) => QrAddress(publicKey))
  );
}

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

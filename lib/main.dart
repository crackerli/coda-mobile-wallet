import 'dart:convert';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/entry_sheet.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global/global.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(CodaWallet());
  });
}

class CodaWallet extends StatelessWidget {
  Future<SharedPreferences> _initStoredData() async {
    globalPreferences = await SharedPreferences.getInstance();
    String rpcServer = globalPreferences.getString(RPC_SERVER_KEY);
    if(null == rpcServer || rpcServer == '') {
      globalPreferences.setString(RPC_SERVER_KEY, DEFAULT_RPC_SERVER);
    }
    String accountsStr = globalPreferences.getString(GLOBAL_ACCOUNTS_KEY);
    if(null != accountsStr && accountsStr.isNotEmpty) {
      Map accountsJson = json.decode(accountsStr);
      globalHDAccounts = MinaHDAccount.fromMap(accountsJson);
    }
    globalEncryptedSeed = globalPreferences.getString(ENCRYPTED_SEED_KEY);
    return globalPreferences;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initStoredData(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            showPerformanceOverlay: false,
            title: 'Mina Wallet',
            routes: globalRoutes,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.white,
              accentColor: Colors.white,
              fontFamily: 'Roboto-Regular'
            ),
            home: EntrySheet(),
            navigatorObservers: [routeObserver]
          );
        } else {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white);
        }
      }
    );
  }
}

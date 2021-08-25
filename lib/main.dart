import 'dart:convert';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/entry_sheet.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global/global.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(CodaWallet());
  });
}

class CodaWallet extends StatelessWidget {
  Future<FlutterSecureStorage> _initStoredData() async {
    globalSecureStorage = FlutterSecureStorage();
    globalPreferences = await SharedPreferences.getInstance();
    int? currentNetworkId = globalPreferences.getInt(CURRENT_NETWORK_ID);
    print('Current network id: $currentNetworkId');

    bool? migrated = globalPreferences.getBool(METADATA_MIGRATED_KEY);
    if(null == migrated) {
      print('1. Read old data from sharedpreferences');
      String? accountsStr = globalPreferences.getString(GLOBAL_ACCOUNTS_KEY);
      if(null != accountsStr && accountsStr.isNotEmpty) {
        Map<String, dynamic> accountsJson = json.decode(accountsStr);
        globalHDAccounts = MinaHDAccount.fromMap(accountsJson)!;
      }
      globalEncryptedSeed = globalPreferences.getString(ENCRYPTED_SEED_KEY);
      if(null != globalEncryptedSeed &&
         globalEncryptedSeed!.isNotEmpty &&
         null != accountsStr &&
         accountsStr.isNotEmpty
        ) {
        print('2. Detect old data, fill them in secure storage');
        // Migrate account metadata from sharedpreferences to secure storage.
        await globalSecureStorage.write(key: ENCRYPTED_SEED_KEY, value: globalEncryptedSeed);
        await globalSecureStorage.write(key: GLOBAL_ACCOUNTS_KEY, value: accountsStr);
      } else {
        // Maybe this is a empty wallet, ignore migration
        print('2. Not detect old data, new wallet');
      }

      print('3. Force reset metadata in sharedpreferences');
      // Force clean the old metadata stored in sharedpreferences
      globalPreferences.setString(ENCRYPTED_SEED_KEY, '');
      globalPreferences.setString(GLOBAL_ACCOUNTS_KEY, '');
      globalPreferences.setBool(METADATA_MIGRATED_KEY, true);
    } else {
      print('1. Metadata migrated, read from secure storage');
      // All data was migrated, read them from secure storage
      Map<String, String> metaData = await globalSecureStorage.readAll();
      globalEncryptedSeed = metaData[ENCRYPTED_SEED_KEY];
      String? accountsStr = metaData[GLOBAL_ACCOUNTS_KEY];
      if(null != accountsStr && accountsStr.isNotEmpty) {
        Map<String, dynamic> accountsJson = json.decode(accountsStr);
        globalHDAccounts = MinaHDAccount.fromMap(accountsJson)!;
      }
    }
    return globalSecureStorage;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initStoredData(),
      builder: (BuildContext context, AsyncSnapshot<FlutterSecureStorage> snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            showPerformanceOverlay: false,
            title: 'StakingPower Wallet',
            //debugShowCheckedModeBanner:false,
            routes: globalRoutes,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.white,
              accentColor: Colors.white,
              // fontFamily: 'Roboto-Regular'
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

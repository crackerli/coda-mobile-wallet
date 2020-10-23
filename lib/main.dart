import 'package:coda_wallet/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coda_wallet/owned_wallets/screens/owned_accounts_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global/global.dart';
import 'owned_wallets/blocs/owned_accounts_bloc.dart';
import 'owned_wallets/blocs/owned_accounts_states.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(CodaWallet());
  });
}

class CodaWallet extends StatelessWidget {
  Future<SharedPreferences> _initRPCServer() async {
    globalPreferences = await SharedPreferences.getInstance();
    String rpcServer = globalPreferences.getString(RPC_SERVER_KEY);
    if(null == rpcServer || rpcServer == '') {
      globalPreferences.setString(RPC_SERVER_KEY, DEFAULT_RPC_SERVER);
    }
    return globalPreferences;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initRPCServer(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return BlocProvider<OwnedAccountsBloc>(
            create: (context) => OwnedAccountsBloc(FetchOwnedAccountsLoading(null)),
            child: MaterialApp(
              showPerformanceOverlay: false,
              title: 'Coda Wallet',
              theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: Color(0xfff5f8fd),
                accentColor: Colors.cyan[600],
                fontFamily: 'Roboto-Regular'
              ),
              home: OwnedAccountsScreen(),
              navigatorObservers: [routeObserver]
            )
          );
        } else {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,);
        }

    });

  }
}

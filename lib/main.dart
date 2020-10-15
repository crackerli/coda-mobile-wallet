import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coda_wallet/owned_wallets/screens/owned_accounts_screen.dart';
import 'owned_wallets/blocs/owned_accounts_bloc.dart';
import 'owned_wallets/blocs/owned_accounts_states.dart';

void main() {
  runApp(CodaWallet());
}

class CodaWallet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OwnedAccountsBloc>(
      create: (context) => OwnedAccountsBloc(FetchOwnedAccountsLoading()),
      child: MaterialApp(
        showPerformanceOverlay: false,
        title: 'Coda Wallet',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xfff7f8fa),
          accentColor: Colors.cyan[600],
          fontFamily: 'NotoSans-Regular'
        ),
        home: OwnedAccountsScreen()
      )
    );
  }
}

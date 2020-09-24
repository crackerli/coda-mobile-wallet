import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coda_wallet/account_txns/screens/account_txns_screen.dart';
import 'account_txns/blocs/account_txns_bloc.dart';
import 'account_txns/blocs/account_txns_events.dart';
import 'account_txns/query/account_txns_query.dart';
import 'package:coda_wallet/owned_wallets/screens/owned_accounts_screen.dart';
import 'owned_wallets/blocs/owned_accounts_bloc.dart';
import 'owned_wallets/blocs/owned_accounts_events.dart';
import 'owned_wallets/query/owned_accounts_query.dart';
import 'owned_wallets/blocs/owned_accounts_states.dart';

void main() {
  runApp(CodaWallet());
}

class CodaWallet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OwnedAccountsBloc>(
      create: (BuildContext context) => OwnedAccountsBloc(Loading())..add(FetchOwnedAccountsData(OWNED_ACCOUNTS_QUERY)),
      child: MaterialApp(
        title: 'Coda Wallet',
        home: OwnedAccountsScreen(),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //       title: 'Coda Wallet',
  //       theme: ThemeData(primarySwatch: Colors.blue),
  //       home: BlocProvider<OwnedAccountsBloc>(
  //           create: (BuildContext context) => OwnedAccountsBloc()..add(FetchOwnedAccountsData(OWNED_ACCOUNTS_QUERY)),
  //           child: OwnedAccountsScreen()
  //       )
  //   );
  // }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final _ownedAccountsBloc = OwnedAccountsBloc(FetchOwnedAccountsLoading());
    return BlocProvider<OwnedAccountsBloc>(
      create: (BuildContext context) => _ownedAccountsBloc,//..add(FetchOwnedAccountsData(OWNED_ACCOUNTS_QUERY)),
      child: MaterialApp(
        title: 'Coda Wallet',
        home: OwnedAccountsScreen(),
      ),
    );
  }
}

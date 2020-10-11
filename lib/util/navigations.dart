import 'package:coda_wallet/account_txns/blocs/account_txns_bloc.dart';
import 'package:coda_wallet/account_txns/blocs/account_txns_states.dart';
import 'package:coda_wallet/account_txns/screens/account_txns_screen.dart';
import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_models.dart';
import 'package:coda_wallet/qr_address/qr_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

toAccountTxnsScreen(BuildContext context, Account account) {

  Navigator.push(context,
    MaterialPageRoute(builder: (context) {
      return BlocProvider<AccountTxnsBloc>(
        create: (BuildContext context) {
          return AccountTxnsBloc(RefreshAccountTxnsLoading(), account.publicKey);
        },
        child: AccountTxnsScreen(account)
      );
    }
  ));
}

toQrAddressScreen(BuildContext context, String publicKey) {
  Navigator.push(context,
    MaterialPageRoute(builder: (context) => QrAddress(publicKey))
  );
}
import 'package:coda_wallet/account_txns/blocs/account_txns_bloc.dart';
import 'package:coda_wallet/account_txns/blocs/account_txns_states.dart';
import 'package:coda_wallet/account_txns/screens/account_txns_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

toAccountTxnsScreen(BuildContext context, String publicKey) {

  Navigator.push(context,
      MaterialPageRoute(builder: (context) {
        return BlocProvider<AccountTxnsBloc>(
            create: (BuildContext context) {
              return AccountTxnsBloc(Loading());
            },
            child: AccountTxnsScreen(publicKey)
        );
      }
    )
  );
}
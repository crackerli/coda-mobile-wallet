import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_bloc.dart';
import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_events.dart';
import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_models.dart';
import 'package:coda_wallet/owned_wallets/mutation/owned_accounts_mutation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

_toggleLockStatus(BuildContext context, Account content, String password) {
  Map<String, String> variables = Map<String, String>();
  variables['publicKey'] = content.publicKey;
  variables['password'] = password;
  final _ownedAccountsBloc = BlocProvider.of<OwnedAccountsBloc>(context);
  _ownedAccountsBloc.add(ToggleLockStatus(ACCOUNT_UNLOCK_MUTATION, variables: variables));
}

void showUnlockAccountDialog(BuildContext context, Account content) {
  String password = '';
  final textField = TextField(
    onChanged: (val) {
      password = val;
    }
  );
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Unlock Account"),
        content: textField,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              _toggleLockStatus(context, content, password);
              Navigator.of(context).pop();
            },
            child: Text("OK")
          ),
          FlatButton(
            onPressed: () { Navigator.of(context).pop(); },
            child: Text("Cancel")
          )
        ]
      );
    });
}

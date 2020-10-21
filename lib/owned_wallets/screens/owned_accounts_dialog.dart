import 'package:coda_wallet/global/mutation/toggle_lock_status.dart';
import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_bloc.dart';
import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_events.dart';
import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_entity.dart';
import 'package:coda_wallet/owned_wallets/mutation/owned_accounts_mutation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

_toggleLockStatus(
  BuildContext context, Account account,
  bool toLock, { String password }) {

  Map<String, String> variables = Map<String, String>();
  variables['publicKey'] = account.publicKey;
  final _ownedAccountsBloc = BlocProvider.of<OwnedAccountsBloc>(context);

  if(toLock) {
    _ownedAccountsBloc.add(ToggleLockStatus(ACCOUNT_LOCK_MUTATION, variables: variables));
  } else {
    variables['password'] = password;
    _ownedAccountsBloc.add(
        ToggleLockStatus(ACCOUNT_UNLOCK_MUTATION, variables: variables));
  }
}

void showUnlockAccountDialog(BuildContext context, Account account) {
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
        title: Text('Unlock Account'),
        content: textField,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              _toggleLockStatus(context, account, false, password: password);
              Navigator.of(context).pop();
            },
            child: Text('OK')
          ),
          FlatButton(
            onPressed: () { Navigator.of(context).pop(); },
            child: Text('Cancel')
          )
        ]
      );
    });
}

void showLockAccountDialog(BuildContext context, Account account) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Lock Account'),
        content: Text('Confirm to lock account?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              _toggleLockStatus(context, account, true);
              Navigator.of(context).pop();
            },
            child: Text('OK')
          ),
          FlatButton(
            onPressed: () { Navigator.of(context).pop(); },
            child: Text('Cancel')
          )
        ]
      );
    }
  );
}

_createNewAccount(BuildContext context, String password) {
  Map<String, String> variables = Map<String, String>();
  variables['password'] = password;
  final _ownedAccountsBloc = BlocProvider.of<OwnedAccountsBloc>(context);

  _ownedAccountsBloc.add(
    CreateAccount(CREATE_ACCOUNT_MUTATION, variables: variables));
}

void showCreateAccountDialog(BuildContext context) {
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
        title: Text('Create new account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please input the account password'),
            textField
          ]
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              _createNewAccount(context, password);
            },
            child: Text('OK')
          ),
          FlatButton(
            onPressed: () { Navigator.of(context).pop(); },
            child: Text('Cancel')
          )
        ]
      );
    }
  );
}

import 'package:coda_wallet/global/mutation/toggle_lock_status_mutation.dart';
import 'package:coda_wallet/send_token/blocs/send_token_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coda_wallet/send_token/blocs/send_token_events.dart';

_toggleLockStatus(
    BuildContext context, String publicKey,
    bool toLock, { String password }) {

  Map<String, String> variables = Map<String, String>();
  variables['publicKey'] = publicKey;
  final SendTokenBloc sendTokenBloc = BlocProvider.of<SendTokenBloc>(context);

  if(toLock) {
    sendTokenBloc.add(ToggleLockStatus(ACCOUNT_LOCK_MUTATION, variables: variables));
  } else {
    variables['password'] = password;
    sendTokenBloc.add(
        ToggleLockStatus(ACCOUNT_UNLOCK_MUTATION, variables: variables));
  }
}

void showUnlockAccountDialog(BuildContext buildContext, String publicKey) {
  String password = '';
  final textField = TextField(
    onChanged: (val) {
      password = val;
    }
  );

  showDialog(
    context: buildContext,
    builder: (_) => BlocProvider<SendTokenBloc>.value(
      value: buildContext.bloc<SendTokenBloc>(),
      child: AlertDialog(
        title: Text('Unlock Account'),
        content: textField,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              _toggleLockStatus(buildContext, publicKey, false, password: password);
              Navigator.of(buildContext).pop();
            },
            child: Text('OK')
          ),
          FlatButton(
            onPressed: () => Navigator.of(buildContext).pop(),
            child: Text('Cancel')
          )
        ]
      ),
    )
  );
}

void showLockAccountDialog(BuildContext buildContext, String publicKey) {
  showDialog(
    context: buildContext,
    builder: (_) => BlocProvider<SendTokenBloc>.value(
      value: buildContext.bloc<SendTokenBloc>(),
      child: AlertDialog(
        title: Text('Lock Account'),
        content: Text('Confirm to lock account?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              _toggleLockStatus(buildContext, publicKey, true);
              Navigator.of(buildContext).pop();
            },
            child: Text('OK')
          ),
          FlatButton(
            onPressed: () => Navigator.of(buildContext).pop(),
            child: Text('Cancel')
          )
        ]
      )
    )
  );
}

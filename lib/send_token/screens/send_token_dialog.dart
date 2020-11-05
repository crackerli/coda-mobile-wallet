import 'package:coda_wallet/global/mutation/toggle_lock_status_mutation.dart';
import 'package:coda_wallet/send_token/blocs/send_token_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coda_wallet/send_token/blocs/send_token_events.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

void showSendSuccessDialog(
  BuildContext buildContext,
  String receiver,
  String amount,
  String memo,
  String fee) {

  showDialog(
    context: buildContext,
    builder: (BuildContext context) =>
      ButtonBarTheme(
        data: ButtonBarThemeData(alignment: MainAxisAlignment.center),
        child: AlertDialog(
          title: Text('Mina sent', style: TextStyle(fontWeight: FontWeight.bold),),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Receiver: $receiver", textAlign: TextAlign.left, style: TextStyle(decoration: TextDecoration.underline),),
              Container(height: 4),
              Text("Amount: $amount", textAlign: TextAlign.left, style: TextStyle(decoration: TextDecoration.underline)),
              Container(height: 4),
              Text("Fee: $fee", textAlign: TextAlign.left, style: TextStyle(decoration: TextDecoration.underline)),
              Container(height: 4),
              Text("memo: $memo", textAlign: TextAlign.left, style: TextStyle(decoration: TextDecoration.underline))
            ]
          ),
          actions: <Widget>[
            RaisedButton(
              padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 60, right: 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
              onPressed: () => Navigator.of(buildContext).pop(),
              color: Colors.blueAccent,
              child: Text('OK', style: TextStyle(color: Colors.white),)
            )
          ]
        )
      )
  );
}



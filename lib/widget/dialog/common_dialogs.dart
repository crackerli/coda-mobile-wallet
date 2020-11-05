import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showInfoDialog(
  BuildContext buildContext,
  String infoTitle,
  String infoContent
  ) {

  showDialog(
    context: buildContext,
    builder: (BuildContext context) =>
      ButtonBarTheme(
        data: ButtonBarThemeData(alignment: MainAxisAlignment.center),
        child: AlertDialog(
          title: Text(infoTitle, style: TextStyle(fontWeight: FontWeight.bold)),
          content:
            Text("$infoContent", textAlign: TextAlign.left, style: TextStyle(decoration: TextDecoration.underline),),
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
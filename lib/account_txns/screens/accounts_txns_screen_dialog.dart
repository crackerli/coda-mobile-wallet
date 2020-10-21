import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<String> showEditAccountNameDialog(BuildContext context) async {
  String editName = '';
  final textField = TextField(
    onChanged: (val) {
      editName = val;
    }
  );

  var inputName = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit account name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please input account name'),
            textField
          ]
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(editName);
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
  return inputName;
}
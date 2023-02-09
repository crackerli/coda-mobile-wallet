import 'dart:io';

import 'package:coda_wallet/qr_address/qr_image_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QrAddress extends StatelessWidget {
  final String _publicKey;
  final GlobalKey _qrImageKey = GlobalKey();

  QrAddress(this._publicKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qr Address'),
        centerTitle: true,
        elevation: 0,
      ),
      body: RepaintBoundary(
        key: _qrImageKey,
        child: _buildQrBody(context)
      )
    );
  }

  Widget _buildQrBody(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImage(data: _publicKey, size: 200.0, version: QrVersions.auto),
            Container(height: 10),
            Text('$_publicKey', maxLines: 2, textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 16.0)),
            Container(height: 10),
            Builder(builder: (context) =>
              RaisedButton(
                padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 60, right: 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
                onPressed: () async { await _checkStoragePermission(context); },
                color: Colors.blueAccent,
                child: Text('Share', style: TextStyle(color: Colors.white),)
              )
            )
          ]
        )
      )
    );
  }

  Future _checkStoragePermission(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    var status = await Permission.storage.status;
    print(status);
    if (status.isGranted) {
      saveImageAsFile(_qrImageKey).then((value) {
        _shareQrImage(context, value!);
      });
    } else {
      openAppSettings();
    }
  }

  _shareQrImage(BuildContext context, String path) {
    String text = Platform.isAndroid ?
      'Image saved: $path' :
      'Image saved to gallery';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
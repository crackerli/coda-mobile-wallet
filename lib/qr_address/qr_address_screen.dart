import 'package:coda_wallet/util/format_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QrAddress extends StatelessWidget {
  final String _publicKey;

  const QrAddress(this._publicKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qr Address'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _buildQrBody()
    );
  }

  Widget _buildQrBody() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child:
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImage(data: _publicKey, size: 200.0),
              Container(height: 10),
              Text('$_publicKey', maxLines: 2, textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 16.0))
          ]
        )
      )
    );
  }
}
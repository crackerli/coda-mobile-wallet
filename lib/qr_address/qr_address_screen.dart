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
      child:
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImage(data: _publicKey, size: 200.0),
              Text('${formatHashEllipsis(_publicKey)}', style: TextStyle(color: Colors.black54, fontSize: 24.0))
          ]
        )
      )
    );
  }
}
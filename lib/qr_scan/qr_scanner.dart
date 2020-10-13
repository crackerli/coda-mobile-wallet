import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  var _scannedText = '';
  QRViewController _qrViewController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _hasPopped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: _qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.blueAccent,
          borderRadius: 4,
          borderLength: 30,
          borderWidth: 6,
          cutOutSize: 200,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this._qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      if(null != scanData && scanData.length > 1 && !_hasPopped) {
        _hasPopped = true;
        Navigator.pop(context, scanData);
      }
    });
  }

  @override
  void dispose() {
    _qrViewController.dispose();
    super.dispose();
  }
}
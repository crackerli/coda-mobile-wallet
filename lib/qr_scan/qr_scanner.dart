import 'package:coda_wallet/constant/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  late QRViewController _qrViewController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _hasPopped = false;
  bool _isFlashOn = false;

  PreferredSize _buildQrScannerAppBar() {
    return PreferredSize(
      child: AppBar(
        title: Text('Qr Scan',
          style: TextStyle(fontSize: 17.sp, color: Color(0xff0b0f12))),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          tooltip: 'Navigation',
          onPressed: () => Navigator.pop(context, ''),
        ),
        actions: [
          IconButton(
            icon: _isFlashOn ? Icon(Icons.flash_on) : Icon(Icons.flash_off),
            tooltip: 'Flash',
            iconSize: 24.w,
            onPressed: _toggleFlash,
          )
        ]
      ),
      preferredSize: Size.fromHeight(APPBAR_HEIGHT.h)
    );
  }

  _toggleFlash() {
    _qrViewController.toggleFlash();
    setState(() {
      _isFlashOn = !_isFlashOn;
    });

  }

  @override
  Widget build(BuildContext context) {
  //  ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: Size(375, 812),
      orientation: Orientation.portrait
    );
    return WillPopScope(
      child: Scaffold(
        appBar: _buildQrScannerAppBar(),
        body: QRView(
          key: _qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Colors.blueAccent,
            borderRadius: 4,
            borderLength: 30,
            borderWidth: 6,
            cutOutSize: 200.w,
          ),
        ),
      ),
      onWillPop: () async {
        Navigator.pop(context, '');
        return true;
      }
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this._qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      if(!_hasPopped) {
        _hasPopped = true;
        Navigator.pop(context, scanData.code);
      }
    });
  }

  @override
  void dispose() {
    _qrViewController.dispose();
    super.dispose();
  }
}
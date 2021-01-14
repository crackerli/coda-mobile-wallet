import 'dart:io';

import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/qr_address/qr_image_helper.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveAccountScreen extends StatefulWidget {
  ReceiveAccountScreen({Key key}) : super(key: key);

  @override
  _ReceiveAccountScreenState createState() => _ReceiveAccountScreenState();
}

class _ReceiveAccountScreenState extends State<ReceiveAccountScreen> {
  final GlobalKey _qrImageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    int index = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildNoTitleAppBar(context),
      body: RepaintBoundary(
        key: _qrImageKey,
        child: Container(child:
          _buildReceiveAccountBody(context, index),
          color: Colors.white,
        )
      ),
    );
  }

  _buildReceiveAccountBody(BuildContext context, int index) {
    String address = globalHDAccounts.accounts[index].address;
    String accountName = globalHDAccounts.accounts[index].accountName;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.bottomCenter,
          image: AssetImage('images/common_bg.png',),
          fit: BoxFit.fitWidth
        ),
      ),
      child: Column(
      children: [
        Container(height: 24.h),
        Image.asset('images/mina_logo_black_inner.png', width: 66.w, height: 66.w),
        Container(height: 14.h),
        QrImage(data: address, size: 200.w, version: QrVersions.auto),
        Container(height: 33.h),
        Text(accountName, textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: Colors.black)),
        Container(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xffe6e5eb),
            borderRadius: BorderRadius.circular(7.w),
            shape: BoxShape.rectangle,
          ),
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 13.h, bottom: 13.h),
          margin: EdgeInsets.only(left: 51.w, right: 51.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Builder(builder: (context) =>
                InkWell(
                  child: Image.asset('images/copy_gray.png', width: 18.w, height: 18.w),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: address));
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Your address copied into clipboard!!')));
                  },
                )
              ),
              Container(width: 20.w),
              Flexible(child:
                Text(address, textAlign: TextAlign.left, softWrap: true,
                  style: TextStyle(fontSize: 12.sp, color: Color(0xff786666)), maxLines: 2)),
            ],
          )
        ),
        Container(height: 20.h),
        Builder(builder: (context) =>
          InkWell(
            onTap: () async { await _checkStoragePermission(context); },
            child: Container(
              padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 70.w, right: 70.w),
              decoration: getMinaButtonDecoration(topColor: Color(0xff9fe4c9)),
              child: Text('SAVE IMAGE', style: TextStyle(color: Colors.black),),
            ),
          )
        )
      ],
    ));
  }

  Future _checkStoragePermission(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    var status = await Permission.storage.status;
    print(status);
    if (status.isUndetermined) {
      openAppSettings();
    } else {
      saveImageAsFile(_qrImageKey).then((value) {
        _saveQRImage(context, value);
      });
    }
  }

  _saveQRImage(BuildContext context, String path) {
    String text = Platform.isAndroid ?
    'Image saved: $path' :
    'Image saved to gallery';
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}


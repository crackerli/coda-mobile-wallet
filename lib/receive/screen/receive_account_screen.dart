import 'dart:io';

import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/qr_address/qr_image_helper.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/dialog/bottom_sheet_social_share_dialog.dart';
import 'package:coda_wallet/widget/dialog/loading_dialog.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:coda_wallet/widget/ui/custom_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';

class ReceiveAccountScreen extends StatefulWidget {
  ReceiveAccountScreen({Key? key}) : super(key: key);

  @override
  _ReceiveAccountScreenState createState() => _ReceiveAccountScreenState();
}

class _ReceiveAccountScreenState extends State<ReceiveAccountScreen> {
  // Global key to the painted widgets, include the qr code image, public key text.
  // Then we can save them into a image for social share purpose.
  final GlobalKey _qrImageKey = GlobalKey();
  bool _addressCopied = false;
  late int _accountIndex;

  @override
  void initState() {
    super.initState();
    _addressCopied = false;
  }

  @override
  void dispose() {
    _addressCopied = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: Size(375, 812),
      orientation: Orientation.portrait
    );
    int index = ModalRoute.of(context)!.settings.arguments as int;
    _accountIndex = index;
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
    String? address = globalHDAccounts.accounts![index]!.address;
    String? accountName = globalHDAccounts.accounts![index]!.accountName;
    return Container(
      decoration: BoxDecoration(
        gradient: backgroundGradient
      ),
      child: Column(
      children: [
        Container(height: 24.h),
        Image.asset('images/mina_logo_black_inner.png', width: 66.w, height: 66.w),
        Container(height: 14.h),
        QrImage(data: address ?? '', size: 200.w, version: QrVersions.auto),
        Container(height: 33.h),
        Text(accountName ?? '', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.sp, color: Color(0xff212121), fontWeight: FontWeight.w500)),
        Container(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _addressCopied ? Color(0xff616161) : Color(0xffbdbdbd),
            borderRadius: BorderRadius.circular(4.w),
            shape: BoxShape.rectangle,
          ),
          padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 13.h, bottom: 13.h),
          margin: EdgeInsets.only(left: 51.w, right: 51.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Builder(builder: (context) =>
                InkWell(
                  child: Image.asset(_addressCopied ? 'images/copy_white.png' : 'images/copy_gray.png', width: 22.w, height: 27.h),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: address));
                    setState(() {
                      _addressCopied = true;
                    });
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Your address copied into clipboard!!')));
                    });
                  },
                )
              ),
              Container(width: 8.w),
              Flexible(child:
                Text(address ?? '', textAlign: TextAlign.left, softWrap: true,
                  style: TextStyle(fontSize: 12.sp, color: _addressCopied ? Colors.white : Color(0xff616161)), maxLines: 3)),
            ],
          )
        ),
        Container(height: 20.h),
        Builder(builder: (context) =>
          InkWell(
            onTap: () async { await _checkStoragePermission(context); },
            child: Container(
              padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 70.w, right: 70.w),
              decoration: getMinaButtonDecoration(topColor: Colors.white),
              child: Text('SHARE', style: TextStyle(color: Color(0xff2d2d2d), fontSize: 12.sp, fontWeight: FontWeight.w600),),
            ),
          )
        )
      ],
    ));
  }

  _checkStoragePermission(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    var status = await Permission.storage.status;
    print(status);
    if(status.isGranted) {
      const url = 'weixin://';

      try {
        ProgressDialog.showProgress(context);
        String? path = await saveImageAsFile(_qrImageKey);
        Map? installedApp = await SocialShare.checkInstalledAppsForShare();

        bool wechatInstalled = await canLaunch(url);
        ProgressDialog.dismiss(context);
        if(null != installedApp) {
          installedApp['wechat'] = wechatInstalled;
        }
        _notifyImageSaved(context, path, installedApp);
      } catch(e) {
        ProgressDialog.dismiss(context);
        return;
      }
    } else {
      openAppSettings();
    }
  }

  _notifyImageSaved(BuildContext context, String? path, Map? installedApp) {
    String? address = globalHDAccounts.accounts![_accountIndex]!.address;
    if(Platform.isAndroid) {
      if (null != path && path.isNotEmpty && path.length > 8 && path.startsWith('file://')) {
        showSocialShareSheet(context, address, path.substring(7), installedApp);
      }
    } else {
      showSocialShareSheet(context, address, path, installedApp);
    }
  }
}


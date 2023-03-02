import 'dart:io';

import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:coda_wallet/types/dialog_view_position_types.dart';
import 'package:coda_wallet/widget/dialog/bottom_sheet_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

List<String> _shareNames = [
  'Facebook',
  'Twitter',
  // todo
  // 'Wechat',
  'Instagram',
  'Telegram',
  'Whatsapp',
  // todo
  // 'SMS',
];
List<String> _shareIcons = [
  'images/facebook_share.png',
  'images/twitter_share.png',
  // 'images/wechat_share.png',
  'images/instagram_share.png',
  'images/telegram_share.png',
  'images/whatsapp_share.png',
  // 'images/sms_share.png',
];

List<String> _shareDisableIcons = [
  'images/facebook_share_disable.png',
  'images/twitter_share_disable.png',
  // 'images/wechat_share.png',
  'images/instagram_share_disable.png',
  'images/telegram_share_disable.png',
  'images/whatsapp_share_disable.png',
  // 'images/sms_share_disable.png',
];

AppinioSocialShare _appinioSocialShare = AppinioSocialShare();

List<Function> _shareMethods = [
  (String address, String? path) async {
    //facebook appId is mandatory for andorid or else share won't work
    if(Platform.isAndroid) {
      String result = await _appinioSocialShare.shareToFacebook('My mina address: $address', path!);
      print(result);
    } else {
      XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(null != file) {
        _appinioSocialShare.shareToFacebook('My mina address: $address', '${file?.path ?? ''}');
      }
    }
  },
  (String address, String? path) async {
    _appinioSocialShare.shareToTwitter('My mina address: $address', filePath: path!);
  },
  // todo
  // (String address, String? path) async {
  //   _appinioSocialShare.shareToWeChat('My mina address: $address',
  //       filePath: path!);
  // },
  (String address, String? path) async {
    if(Platform.isAndroid) {
      _appinioSocialShare.shareToInstagramStory(stickerImage: path!);
    } else {
      XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(null != file) {
        _appinioSocialShare.shareToInstagramStory(
          stickerImage: '${file?.path ?? ''}',
          backgroundTopColor: '#ffffff',
          backgroundBottomColor: '#000000',
          attributionURL: 'https://www.staking-power.com');
      }
    }
  },
  (String address, String? path) async {
    _appinioSocialShare.shareToTelegram('My mina address: $address', filePath: path!);
  },
  (String address, String? path) async {
    _appinioSocialShare.shareToWhatsapp('My mina address: $address', filePath: path!);
  },
  // todo
  // (String address, String? path) async {
  //   _appinioSocialShare.shareToSMS('My mina address: $address', filePath: path!);
  // },
];

showSocialShareSheet(BuildContext context, String? address, String? snapshotPath, Map? installedApp) {
  BottomSheetDialog.bottomMaterialDialog(
    title: 'Select an application to share',
    titleStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
    context: context,
      customViewPosition: CustomViewPosition.AFTER_ACTION,
      customView: Container(
        height: 140.h,
        child: Column(children: [
          Container(height: 0.5.h, color:  Color(0xffbdbdbd)),
          Container(
            padding: EdgeInsets.only(top: 10.h),
            height: 120.h,
            child: ListView(
              shrinkWrap: true,
              children: _buildList(context, address, snapshotPath, installedApp),
              scrollDirection: Axis.horizontal,
            )
          )
        ])
      )
  );
}

String _getAppIconFromAssets(Map? installedApp, int index) {
  if (installedApp != null) {
    return installedApp[_shareNames[index].toLowerCase()] ? _shareIcons[index] : _shareDisableIcons[index];
  }

  return _shareDisableIcons[index];
}

List<Widget> _buildList(BuildContext context, String? address, String? snapshotPath, Map? installedApp) {
  List<Widget> result = <Widget>[];
  for (int i = 0; i < _shareNames.length; i++) {
    result.add(_item(context, address, snapshotPath, installedApp, i));
  }
  return result;
}

Widget _item(BuildContext context, String? address, String? snapshotPath, Map? installedApp, int index) {
  return InkWell(
    onTap: () => _onPressShareItem(context, address, snapshotPath, installedApp, index),
    child: Card(
      child: Container(
        width: 80.w,
        height: 60.w,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(_getAppIconFromAssets(installedApp, index), height: 45.w, width: 45.w),
              Container(height: 5),
              Text(_shareNames[index], style: TextStyle(fontSize: 14.sp, color: Colors.black)),
            ],
          ),
        ),
      ),
    ),
  );
}

_onPressShareItem(BuildContext context, String? address, String? snapshotPath,
    Map? installedApp, int index) {
  if (null != installedApp && (installedApp[_shareNames[index].toLowerCase()])) {
    _shareMethods[index](address, snapshotPath);
    Navigator.of(context).pop();
  } else {
    Fluttertoast.showToast(
      msg: '${_shareNames[index]} not installed',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xfff5f5f5),
      textColor: Color(0xff2d2d2d),
      fontSize: 16.sp);
  }
}

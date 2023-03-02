import 'dart:io';

import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:coda_wallet/qr_address/qr_image_helper.dart';
import 'package:coda_wallet/widget/dialog/dialogs.dart';
import 'package:coda_wallet/widget/dialog/dialogs/types.dart';
import 'package:coda_wallet/widget/dialog/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

List<String> _shareNames = [
  'Facebook',
  'Twitter',
  // 'Wechat',
  'Instagram',
  'Telegram',
  'Whatsapp',
  'SMS',
];
List<String> _shareIcons = [
  'images/facebook_share.png',
  'images/twitter_share.png',
//  'images/wechat_share.png',
  'images/instagram_share.png',
  'images/telegram_share.png',
  'images/whatsapp_share.png',
  'images/sms_share.png',
];

List<String> _shareDisableIcons = [
  'images/facebook_share_disable.png',
  'images/twitter_share_disable.png',
// 'images/wechat_share.png',
  'images/instagram_share_disable.png',
  'images/telegram_share_disable.png',
  'images/whatsapp_share_disable.png',
  'images/sms_share_disable.png',
];

AppinioSocialShare appinioSocialShare = AppinioSocialShare();

List<Function> _shareMethods = [
  (String address, String? path) async {
    //facebook appId is mandatory for andorid or else share won't work
    if(Platform.isAndroid) {
      appinioSocialShare.shareToFacebook('My mina address: $address', path!);
    } else {
      XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(null != file) {
        appinioSocialShare.shareToFacebook(
            'My mina address: $address', '${file?.path ?? ''}');
      }
    }
  },
  (String address, String? path) async {
    appinioSocialShare.shareToTwitter('My mina address: $address',
        filePath: path!);
  },
  // (String address, String? path) async {
  //   appinioSocialShare.shareToWeChat('My mina address: $address',
  //       filePath: path!);
  // },
  (String address, String? path) async {
    if(Platform.isAndroid) {
      appinioSocialShare.shareToInstagramStory(stickerImage: path!);
    } else {
      XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(null != file) {
        appinioSocialShare.shareToInstagramStory(
            stickerImage: '${file?.path ?? ''}',
            backgroundTopColor: '#ffffff',
            backgroundBottomColor: '#000000',
            attributionURL: 'https://www.staking-power.com');
      }
    }
  },
  (String address, String? path) async {
    appinioSocialShare.shareToTelegram('My mina address: $address',
        filePath: path!);
  },
  (String address, String? path) async {
    appinioSocialShare.shareToWhatsapp('My mina address: $address',
        filePath: path!);
  },
  (String address, String? path) async {
    appinioSocialShare.shareToSMS('My mina address: $address', filePath: path!);
  },
  (String address, String? path) async {
    appinioSocialShare.shareToSMS('My mina address: $address', filePath: path!);
  },
];

socialShareIos(BuildContext context, String? address, String? imagePath) async {
  final box = context.findRenderObject() as RenderBox?;

  if (imagePath != null) {
    final files = <XFile>[];
    files.add(XFile(imagePath, name: imagePath));
    await Share.shareXFiles(files,
        text: 'My mina address: $address',
        subject: address,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  } else {
    await Share.share(address!,
        subject: address,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }
}

showSocialShareSheet(BuildContext context, String? address,
    String? snapShotPath, Map? installedApp) {
  Dialogs.bottomMaterialDialog(
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
                  children:
                      _budildList(context, address, snapShotPath, installedApp),
                  scrollDirection: Axis.horizontal,
                ))
          ])));
}

String getIconPath(Map? installedApp, int index) {
  if (installedApp != null) {
    if (_shareNames[index].toLowerCase() == "sms") {
      return _shareIcons[index];
    } else {
      return installedApp[_shareNames[index].toLowerCase()]
          ? _shareIcons[index]
          : _shareDisableIcons[index];
    }
  }

  return _shareDisableIcons[index];
}

List<Widget> _budildList(BuildContext context, String? address,
    String? snapShotPath, Map? installedApp) {
  List<Widget> result = <Widget>[];
  for (int i = 0; i < _shareNames.length; i++) {
    result.add(_item(context, address, snapShotPath, installedApp, i));
      }
  return result;
}

Widget _item(BuildContext context, String? address, String? snapShotPath,
    Map? installedApp, int index) {
  return Card(
    child: InkWell(
      onTap: () => _onPressShareItem(
          context, address, snapShotPath, installedApp, index),
      child: Container(
        width: 80.w,
        height: 60.w,
        child: Center(
          child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
              Image.asset(getIconPath(installedApp, index),
                  height: 45.w, width: 45.w),
              const SizedBox(height: 5),
              Text(
                _shareNames[index],
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

_onPressShareItem(BuildContext context, String? address, String? snapShotPath,
    Map? installedApp, int index) {
  if (null != installedApp &&
      (_shareNames[index].toLowerCase() == "sms" ||
          installedApp[_shareNames[index].toLowerCase()])) {
                  _shareMethods[index](address, snapShotPath);
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

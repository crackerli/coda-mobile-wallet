import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_share/social_share.dart';

List<String> _shareNames = ['Facebook', 'Twitter', 'Wechat', 'Instagram', 'Telegram', 'SMS', 'Whatsapp'];
List<String> _shareIcons = [
  'images/facebook_share.png',
  'images/twitter_share.png',
  'images/wechat_share.png',
  'images/instagram_share.png',
  'images/telegram_share.png',
  'images/sms_share.png',
  'images/whatsapp_share.png',
];

List<Function> _shareMethods = [
  (String address, String path) async {
    //facebook appId is mandatory for andorid or else share won't work
    Platform.isAndroid?
      SocialShare.shareFacebookStory(path, "#ffffff", "#000000", '', appId: "1231431000696020")
    : SocialShare.shareFacebookStory(path, "#ffffff", "#000000", '');
  },
  (String address, String path) async {
    SocialShare.shareTwitter('My mina address: $address', url: '', trailingText: '');
  },
  (String address, String path) async {
    SocialShare.shareTwitter('My mina address: $address');
  },
  (String address, String path) async {
    SocialShare.shareInstagramStory(path);
  },
  (String address, String path) async {
    SocialShare.shareTelegram('My mina address: $address');
  },
  (String address, String path) async {
    SocialShare.shareSms('My mina address: $address', url: '', trailingText: '');
  },
  (String address, String path) async {
    SocialShare.shareWhatsapp('My mina address: $address');
  },

];

showSocialShareSheet(BuildContext context, String? address, String? snapShotPath, Map? installedApp) {
  showModalBottomSheet(
    enableDrag: false,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(7.0))),
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: false,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(7.w),
          )
        ),
        margin: EdgeInsets.all(10),
        child: _buildShareList(context, address, snapShotPath, installedApp)
        );
      }
  );
}

Widget _buildShareList(BuildContext context, String? address, String? snapShotPath, Map? installedApp) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(height: 16.h),
        Text('Select one app to share', textAlign: TextAlign.start,
          style: TextStyle(color: Color(0xff2d2d2d), fontSize: 18.sp, fontWeight: FontWeight.w600),),
        Container(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 1.h, childAspectRatio: 1.1),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                if(null != installedApp && installedApp[_shareNames[index].toLowerCase()]) {
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
                    fontSize: 16.sp
                  );
                }
              },
              child: Column(
                children: <Widget>[
                  Image.asset(_shareIcons[index], width: 50.w, height: 50.w,),
                  Text(_shareNames[index], style: TextStyle(fontSize: 16.sp),)
                ],
              )
            );
          },
          itemCount: _shareNames.length,
        ),
        Container(height: 0.5.h, color: Color(0xff2d2d2d)),
        Container(height: 8.h,),
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Text('CANCEL', style: TextStyle(fontSize: 14.sp, color: Color(0xff2d2d2d), fontWeight: FontWeight.w500),
              )
            ),
          ),
        ),
      ],
  );

}

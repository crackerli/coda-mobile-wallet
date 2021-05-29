import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

showSocialShareSheet(BuildContext context) {
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
        child: _buildShareList(context)
        );
      }
  );
}

Widget _buildShareList(BuildContext context) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(height: 6.h),
        Text('Select one app to share', textAlign: TextAlign.start, style: TextStyle(fontSize: 16.sp),),
        Container(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 1.h, childAspectRatio: 1.1),
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Image.asset(_shareIcons[index], width: 50.w, height: 50.w,),
                Text(_shareNames[index], style: TextStyle(fontSize: 16.sp),)
              ],
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
              onTap: () =>Navigator.of(context).pop(),
              child: Text('CANCEL', style: TextStyle(fontSize: 14.sp, color: Color(0xff2d2d2d)),
              )
            ),
          ),
        ),
      ],
  );

}

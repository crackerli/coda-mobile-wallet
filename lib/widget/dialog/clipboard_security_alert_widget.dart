import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClipboardSecurityAlertWidget extends StatefulWidget {

  ClipboardSecurityAlertWidget({Key? key}) : super(key: key);

  @override
  _ClipboardSecurityAlertWidgetState createState() => _ClipboardSecurityAlertWidgetState();
}

class _ClipboardSecurityAlertWidgetState extends State<ClipboardSecurityAlertWidget> {

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
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true, splitScreenMode: false, scaleByHeight: false);

    print('ClipboardSecurityAlertWidget: build(context: $context)');
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 6.h,),
          Row(
            children: [
              Expanded(flex: 1, child: Container(),),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Image.asset('images/close.png', width: 18.w, height: 18.w,),
              )
            ],
          ),
          Container(height: 4.h,),
          Image.asset('images/send_error_alert.png', width: 60.w, height: 51.h,),
          Container(height: 12.h,),
          Text('Your Funds Can Be At Risk', textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeight.w600)),
          Container(height: 32.h,),
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 0.h, 12.w, 0.h),
            child: Text(
              'Your recovery phrase can be exposed to other apps installed on your device, if your device has been compromised by malware,' +
              'resulting in a loss of funds.\n' +
              '\n' +
              'Are you sure you want to copy your recovery phrase?',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16.sp, color: Color(0xff2d2d2d), fontWeight: FontWeight.w500),),
          ),
          Container(height: 32.h,),
          InkWell(
            onTap: () {
              Navigator.of(context).pop(true);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.w),
                color: Color(0xffeeeeee),
                border: Border.all(color: Color(0xffeeeeee), width: 1.w)
              ),
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 42.w, right: 42.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/copy_gray.png', width: 22.w, height: 27.h),
                  Container(width: 6.w,),
                  Text('YES, COPY TO CLIPBOARD', textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
                ],
              )
            )
          ),
          Container(height: 32.h),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Text('NO, I\'LL BACK MY PHRASE UP MANUALLY',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
          ),
          Container(height: 16.h,)
        ],
      )
    );
  }
}

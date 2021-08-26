import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class UnsafeDeviceAlertWidget extends StatefulWidget {
  UnsafeDeviceAlertWidget({Key? key}) : super(key: key);

  @override
  _UnsafeDeviceAlertWidgetState createState() => _UnsafeDeviceAlertWidgetState();
}

class _UnsafeDeviceAlertWidgetState extends State<UnsafeDeviceAlertWidget> {

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
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: Size(375, 812),
      orientation: Orientation.portrait
    );
    print('UnsafeDeviceAlertWidget: build(context: $context)');
    return
      Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 15.h,),
            Image.asset('images/send_error_alert.png', width: 60.w, height: 51.h,),
            Container(height: 12.h,),
            Text(
              'StakingPower wallet detected this device may been rooted or jailbroken, it is an unsafe device.\n' +
                  'All operations on this devices is not recommended.\n' +
                  'Please well-known what you are doing with this device if you want to continue.\n' +
                  'Or you\'d better switch to another safe device to use StakingPower wallet.',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16.sp, color: Color(0xff2d2d2d), fontWeight: FontWeight.w500),),
            Container(height: 16.h,),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 70.w, right: 70.w),
                decoration: getMinaButtonDecoration(topColor: Color(0xffe0e0e0)),
                child: Text('UNDERSTAND',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
              ),
            ),
            Container(height: 16.h,)
          ],
        )
    );
  }
}

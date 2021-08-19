import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class UpgradeCipherWidget extends StatefulWidget {
  UpgradeCipherWidget({Key? key}) : super(key: key);

  @override
  _UpgradeCipherWidgetState createState() => _UpgradeCipherWidgetState();
}

class _UpgradeCipherWidgetState extends State<UpgradeCipherWidget> {

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
    print('UpgradeWidget: build(context: $context)');
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 15.h,),
          Text(
            'New anti-gpu cipher algorithm was added to encrypt seed.' +
            'It can be default option in future.' +
            'Please upgrade your cipher algorithm to re-encrypt your seed.\n' +
            'Goto \"Settings->Change Password\" to re-encrypt seed, then new cipher text is anti-gpu and can be more safer.',
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

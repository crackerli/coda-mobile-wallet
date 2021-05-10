import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountNoStakeScreen extends StatefulWidget {
  AccountNoStakeScreen({Key key}) : super(key: key);

  @override
  _AccountNoStakeScreenState createState() => _AccountNoStakeScreenState();
}

class _AccountNoStakeScreenState extends State<AccountNoStakeScreen> {

  int _accountIndex;

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
    print('AccountNoStakeScreen build()');
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    _accountIndex = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildNoTitleAppBar(context, leading: true),
      body: SafeArea(
        child: Column(
          children: [
            Container(height: 42.h),
            Container(
              width: double.infinity,
              child: Center(
                child: Image.asset('images/stake_logo_deep_color.png', width: 80.w, height: 80.w,),
              )
            ),
            Container(height: 24.h,),
            Text('Put Your Assets to Work', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.normal, color: Color(0xff2d2d2d)),),
            Container(height: 24.h,),
            Padding(
              padding: EdgeInsets.only(left: 38.w, right: 38.w),
              child: Text(
                'Delegate your MINA tokens to a staking provider, and earn more MINA.\n\n'+
                'Staked tokens stay under your control, and can be transferred at anytime.',
                textAlign: TextAlign.left, style: TextStyle(fontSize: 18.sp, color: Colors.black),),
            ),
            Container(height: 188.h,),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  StakeProviderRoute, arguments: _accountIndex);
              },
            child: Container(
              padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 60.w, right: 60.w),
              decoration: getMinaButtonDecoration(topColor: Color(0xffeeeeee)),
              child: Text('SELECT A STAKING PROVIDER',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
            )
            ),
          ],
        )
      )
    );
  }
}
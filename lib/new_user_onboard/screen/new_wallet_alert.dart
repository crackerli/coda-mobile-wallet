import 'dart:ui';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewWalletAlertScreen extends StatefulWidget {
  NewWalletAlertScreen({Key? key}) : super(key: key);

  @override
  _NewWalletAlertScreenState createState() => _NewWalletAlertScreenState();
}

class _NewWalletAlertScreenState extends State<NewWalletAlertScreen> {

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
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: buildNoTitleAppBar(context, actions: false, backgroundColor: Color(0xfff5f5f5)),
      body: Padding(
        padding: EdgeInsets.only(left: 32.w, right: 32.w),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _buildNewWalletAlertBody(context),
            Positioned(
              bottom: 67.h,
              child: InkWell(
                onTap: () => Navigator.of(context).pushNamed(RecoveryPhraseRoute),
                child: Container(
                  padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 100.w, right: 100.w),
                  decoration: getMinaButtonDecoration(topColor: Color(0xffe0e0e0)),
                  child: Text('I UNDERSTAND',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
                )
              )
            )
          ],
        )
      )
    );
  }

  _buildNewWalletAlertBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('images/new_wallet_alert.png', height: 100.h, width: 100.h,),
        Container(height: 24.h,),
        Text('Are You Being Watched?', textAlign: TextAlign.center, style: TextStyle(fontSize: 28.sp, color: Color(0xff2d2d2d)),),
        Container(height: 29.h,),
        Text(
          'You are about to be shown your recovery phrase.\n\nLook around. Are there any video cameras'
          ' in you vicinity?\n\nView your recovery phrase in private, where no one can see you.',
          textAlign: TextAlign.left, style: TextStyle(fontSize: 16.sp),)
      ],
    );
  }
}
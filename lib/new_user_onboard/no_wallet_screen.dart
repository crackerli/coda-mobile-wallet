import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoWalletScreen extends StatefulWidget {
  NoWalletScreen({Key key}) : super(key: key);

  @override
  _NoWalletScreenState createState() => _NoWalletScreenState();
}

class _NoWalletScreenState extends State<NoWalletScreen> {

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
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: _buildNoWalletBody()
    );
  }

  _buildNoWalletBody() {
    return Container(
      padding: EdgeInsets.only(left: 54.w, right: 54.w),
      child: Column(
        children: [
          Container(height: 14.h),
          Container(
            width: 75.w,
            height: 75.w,
            color: Colors.grey,
          ),
          Container(height: 64.h),
          Text('SEND TO', ),
        ]
      ),
    );
  }
}

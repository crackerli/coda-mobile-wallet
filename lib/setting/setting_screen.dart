import 'package:coda_wallet/route/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with AutomaticKeepAliveClientMixin {

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
      backgroundColor: Color(0xfff5f5f5),
      appBar: null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: _buildSettingItems(context)
        )
      )
    );
  }

  _buildSettingItems(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 40.h),
        Padding(
          padding: EdgeInsets.only(left: 14.w),
          child: Text('ACCOUNTS', textAlign: TextAlign.left,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
        ),
        Container(height: 10.h),
        _buildOuterBorder(),
        InkWell(
          onTap: () => Navigator.of(context).pushNamed(MyAccountsRoute),
          child: _buildSettingItem(context, 'My Accounts')
        ),
        _buildOuterBorder(),
        Container(height: 42.h),
        Padding(
          padding: EdgeInsets.only(left: 14.w),
          child: Text('SECURITY', textAlign: TextAlign.left,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
        ),
        Container(height: 10.h),
        _buildOuterBorder(),
        _buildSettingItem(context, 'Recovery Phrase'),
        _buildInnerBorder(),
        _buildSettingItem(context, 'App Lock'),
        _buildInnerBorder(),
        _buildSettingItem(context, 'Restore Wallet'),
        _buildOuterBorder(),
        Container(height: 49.h),
        Padding(
          padding: EdgeInsets.only(left: 14.w),
          child: Text('OTHER', textAlign: TextAlign.left,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
        ),
        Container(height: 10.h),
        _buildOuterBorder(),
        _buildSettingItem(context, 'Network Connection'),
        _buildInnerBorder(),
        _buildSettingItem(context, 'Local Fiat Currency'),
        _buildInnerBorder(),
        _buildSettingItem(context, 'Remove Wallet'),
        _buildOuterBorder(),
      ],
    );
  }

  _buildSettingItem(BuildContext context, String settingName) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 11.h, bottom: 11.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: Text(settingName, textAlign: TextAlign.left, style: TextStyle(fontSize: 16.sp),),
          ),
          Image.asset('images/arrow_right.png', width: 8.w, height: 13.h,),
        ],
      ),
    );
  }

  _buildOuterBorder() {
    return Container(
      width: double.infinity,
      height: 0.5.h,
      color: Color.fromARGB(74, 60, 60, 67),
    );
  }

  _buildInnerBorder() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(height: 0.5.h, color: Color(0xffc8c7cc))
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
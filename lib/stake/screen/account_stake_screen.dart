import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountStakeScreen extends StatefulWidget {
  AccountStakeScreen({Key key}) : super(key: key);

  @override
  _AccountStakeScreenState createState() => _AccountStakeScreenState();
}

class _AccountStakeScreenState extends State<AccountStakeScreen> {

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
    print('AccountStakeScreen build()');
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildNoTitleAppBar(context, leading: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child:
          Padding(
            padding: EdgeInsets.only(left: 18.w, right: 18.w),
            child: Column(
            children: [
              Container(height: 42.h),
              Container(
                width: double.infinity,
                child: Center(
                  child: Image.asset('images/account_staked.png', width: 80.w, height: 80.w,),
                )
              ),
              Container(height: 24.h,),
              RichText(
                textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: 'You Are Staking with ',
                      style: TextStyle(fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.normal)),
                  TextSpan(
                    text: 'StakingPower',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp)),
                  ]
                )
              ),
              Container(height: 20.h,),
              Text('Know Your Provider'),
              Container(height: 20.h,),
              _buildProvider(context),
              Container(height: 48.h,),
              Container(
                padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 60.w, right: 60.w),
                decoration: getMinaButtonDecoration(topColor: Color(0xffeeeeee)),
                child: Text('CHANGE STAKING POOL',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
              ),
              Container(height: 20.h,),
            ],
          )
        ))
      )
    );
  }

  _buildProvider(BuildContext context) {
    return Column(children: [
      Container(
        width: double.infinity,
        height: 1.h,
        color: Color(0xff757575)),
      Container(height: 2.h,),
      Container(
        width: double.infinity,
        height: 1.h,
        color: Color(0xff757575)),
      Container(height: 28.h,),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text('TITLE', textAlign: TextAlign.right, maxLines: 2,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d))),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Text('Staking Power',
              textAlign: TextAlign.left, maxLines: 3,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal, color: Color(0xff616161))),
          )
        ],
      ),
      Container(height: 16.h),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text('WEBSITE', textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d))),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Text('https://www.stakingpower.com',
              textAlign: TextAlign.left, maxLines: 3,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal, color: Color(0xff616161))),
          )
        ],
      ),
      Container(height: 16.h),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text('ADDRESS', textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d)),),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Text('B62qfjwi34iakdfajffkjafkasjflsa',
              textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, color: Color(0xff616161)),),
          )
        ],
      ),
      Container(height: 16.h),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text('STAKE SUM', textAlign: TextAlign.right,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d))),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Text('1234567.789', maxLines: 3,
                textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, color: Color(0xff616161))),
          )
        ],
      ),
      Container(height: 16.h,),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text('STAKE PERCENT', textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d)),),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Text('0.09', textAlign: TextAlign.left, maxLines: 2,
                style: TextStyle(fontSize: 13.sp,  color: Color(0xff616161))),
          )
        ],
      ),
      Container(height: 16.h,),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text('FEE', textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d)),),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Text('5%', textAlign: TextAlign.left, maxLines: 2,
                style: TextStyle(fontSize: 13.sp,  color: Color(0xff616161))),
          )
        ],
      ),
      Container(height: 16.h,),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text('PAYOUT TERMS', textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d)),),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Text('1 / Epoch', textAlign: TextAlign.left, maxLines: 2,
              style: TextStyle(fontSize: 13.sp,  color: Color(0xff616161))),
          )
        ],
      ),
      Container(height: 16.h,),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text('CONTACTS', textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d)),),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Text('123456', textAlign: TextAlign.left, maxLines: 2,
                style: TextStyle(fontSize: 13.sp,  color: Color(0xff616161))),
          )
        ],
      ),
      Container(height: 28.h),
      Container(
          width: double.infinity,
          height: 1.h,
          color: Color(0xff757575)),
      Container(height: 2.h,),
      Container(
          width: double.infinity,
          height: 1.h,
          color: Color(0xff757575)),
    ],);
  }
}
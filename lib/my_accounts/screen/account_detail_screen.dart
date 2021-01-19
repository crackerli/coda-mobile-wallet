import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountDetailScreen extends StatefulWidget {

  AccountDetailScreen({Key key}) : super(key: key);

  @override
  _AccountDetailScreenState createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {

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
    print('AccountDetailScreen: build(context: $context)');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildNoTitleAppBar(context),
        body: Stack(
          alignment: Alignment.center,
          children: [
            _buildSendFeeBody(context),
            _buildActionsButton(context)
          ]
        )
    );
  }

  _buildActionsButton(BuildContext context) {
    return Positioned(
        bottom: 60.h,
        child: Builder(builder: (context) => InkWell(
          onTap: null,
          child: Container(
            padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 100.w, right: 100.w),
            decoration: getMinaButtonDecoration(topColor: Color(0xff9fe4c9)),
            child: Text('SEND',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
          ),
        )
        ));
  }

  _buildSendFeeBody(BuildContext context) {

    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 30.h,),
          Text('Transaction Summary', textAlign: TextAlign.left, style: TextStyle(fontSize: 28.sp, color: Color(0xff2d2d2d))),
          Container(height: 17.h,),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: 33.w, left: 50.w, right: 50.w),
                padding: EdgeInsets.only(top: 18.w + 12.h, left: 20.w, right: 20.w, bottom: 12.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.w),
                    color: Colors.white,
                    border: Border.all(color: Color(0xff2d2d2d), width: 1.w)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('FROM', textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
                    Text(globalHDAccounts.accounts[0].address,
                        textAlign: TextAlign.left, style: TextStyle(fontSize: 14.sp, color: Color(0xff2d2d2d))),
                  ],
                ),
              ),
              Positioned(
                  top: 0,
                  child: Image.asset('images/mina_logo_black_inner.png', width: 66.w, height: 66.w,)
              )
            ],
          ),
          Container(height: 28.h,),
        ]
    );
  }
}

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
  int accountIndex = 0;

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
      backgroundColor: Color(0xfff5f5f5),
      appBar: buildNoTitleAppBar(context, actions: false, backgroundColor: Color(0xfff5f5f5)),
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
          decoration: getMinaButtonDecoration(topColor: Color(0xffeeeeee)),
          child: Text('EDIT ACCOUNT',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
        ),
      ))
    );
  }

  _buildSendFeeBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Container(height: 30.h,),
          Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            child: Text(globalHDAccounts.accounts[accountIndex].accountName,
              textAlign: TextAlign.left, style: TextStyle(fontSize: 28.sp, color: Color(0xff2d2d2d)))
          ),
          Container(height: 17.h,),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: 33.w, left: 30.w, right: 30.w),
                padding: EdgeInsets.only(top: 30.w + 12.h, left: 20.w, right: 20.w, bottom: 20.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.w),
                    color: Colors.white,
                    border: Border.all(color: Color(0xff2d2d2d), width: 1.w)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text('BALANCE', textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Color(0xff616161))),
                    Text('7823456.78',
                      textAlign: TextAlign.left, style: TextStyle(fontSize: 32.sp, color: Color(0xff2d2d2d))),
                    Text('\$1234.56',
                      textAlign: TextAlign.left, style: TextStyle(fontSize: 18.sp, color: Color(0xff616161))),
                    Container(height: 19.h,),
                    Text('ADDRESS', textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Color(0xff616161))),
                    Container(height: 3.h,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.w),
                        color: Color(0xffe0e0e0),
                        border: Border.all(color: Color(0xff9e9e9e), width: 1.w)
                      ),
                      padding: EdgeInsets.only(top: 22.h, bottom: 22.h, left: 12.w, right: 12.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('images/copy_gray.png', width: 22.w, height: 27.h,),
                          Container(width: 6.w,),
                          Flexible(child:
                          Text(globalHDAccounts.accounts[accountIndex].address, maxLines: 2, overflow: TextOverflow.visible,
                            textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, color: Color(0xff616161)))),
                        ],
                      )
                    )
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
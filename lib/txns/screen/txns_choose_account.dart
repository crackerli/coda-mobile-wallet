import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/widget/account/account_list.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TxnsChooseAccountScreen extends StatefulWidget {
  TxnsChooseAccountScreen({Key key}) : super(key: key);

  @override
  _TxnsChooseAccountScreenState createState() => _TxnsChooseAccountScreenState();
}

class _TxnsChooseAccountScreenState extends State<TxnsChooseAccountScreen> {

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
    print('TxnsChooseAccountScreen: build(context: $context)');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: buildNoTitleAppBar(context, leading: false),
      body: Container(
        child: _buildSendFromBody(context),
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.bottomCenter,
            image: AssetImage('images/common_bg.png',),
            fit: BoxFit.fitWidth
          ),
        ),
      )
    );
  }

  _buildSendFromBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 30.h),
        Padding(
          padding: EdgeInsets.only(left: 29.w, right: 29.w),
          child: Text('Transactions', textAlign: TextAlign.left,
            style: TextStyle(fontSize: 28.sp, color: Color(0xff2d2d2d), fontWeight: FontWeight.w500)),
        ),
        Container(height: 28.h),
        Padding(
          padding: EdgeInsets.only(left: 29.w, right: 29.w),
          child: Text('SELECT AN ACCOUNT', textAlign: TextAlign.left,
            style: TextStyle(fontSize: 13.sp, color: Color(0xff2d2d2d), fontWeight: FontWeight.w500)),
        ),
        Container(height: 10.h),
        Expanded(
          flex: 1,
          child: buildAccountList(
            (index) {
              eventBus.fire(ChooseAccountTxns(index));
              Navigator.of(context).pop();
            }
          )
        )
      ],
    );
  }
}

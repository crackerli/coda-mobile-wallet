import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/receive/screen/receive_account_screen.dart';
import 'package:coda_wallet/send/screens/send_to_screen.dart';
import 'package:coda_wallet/widget/account/account_list.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendFromScreen extends StatefulWidget {
  SendFromScreen({Key key}) : super(key: key);

  @override
  _SendFromScreenState createState() => _SendFromScreenState();
}

class _SendFromScreenState extends State<SendFromScreen> {

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
      backgroundColor: primaryBackgroundColor,
      appBar: buildAccountsAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 30.h),
          Padding(
            padding: EdgeInsets.only(left: 29.w, right: 29.w),
            child: Text('SEND FROM', textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, color: Color.fromARGB(153, 60, 60, 67))),
          ),
          Container(height: 10.h),
          Expanded(
            flex: 1,
            child: buildAccountList(
              () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SendToScreen()))
              )
            )
          ],
        )
    );
  }
}

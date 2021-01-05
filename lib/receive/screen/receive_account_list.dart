import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/receive/screen/receive_account_screen.dart';
import 'package:coda_wallet/widget/account/account_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReceiveAccountsScreen extends StatefulWidget {
  ReceiveAccountsScreen({Key key}) : super(key: key);

  @override
  _ReceiveAccountsScreenState createState() => _ReceiveAccountsScreenState();
}

class _ReceiveAccountsScreenState extends State<ReceiveAccountsScreen> {

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
      appBar: _buildAccountsAppBar(),
      body: Column(
        children: [
          Container(height: 30.h),
          Padding(
            padding: EdgeInsets.only(left: 29.w, right: 29.w),
            child: Text('Which address do you want to use?', textAlign: TextAlign.left, style: TextStyle(fontSize: 30.sp, color: Colors.black)),
          ),
          Container(height: 37.h),
          Expanded(
            flex: 1,
              child: buildAccountList(
                (index) => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReceiveAccountScreen()))
            )
          )
        ],
      )
    );
  }

  _buildAccountsAppBar() {
    return PreferredSize(
      child: AppBar(
        title: null,
        centerTitle: true,
        elevation: 0,
      ),
      preferredSize: Size.fromHeight(APPBAR_HEIGHT.h)
    );
  }
}


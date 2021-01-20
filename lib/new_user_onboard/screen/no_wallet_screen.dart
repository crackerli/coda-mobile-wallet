import 'package:coda_wallet/route/routes.dart';
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        body: SafeArea(child: _buildNoWalletBody())
      )
    );
  }

  _buildNoWalletBody() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RaisedButton(
          padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 80, right: 80),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
          onPressed: () => Navigator.pushNamed(context, RecoveryPhraseRoute, arguments: null),
          color: Colors.blueAccent,
          child: Text('New Wallet', style: TextStyle(color: Colors.white),)
        ),
        Container(height: 16.h,),
        RaisedButton(
          padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 80, right: 80),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
          onPressed: () => Navigator.pushNamed(context, ImportRecoveryPhraseRoute, arguments: null),
          color: Colors.blueAccent,
          child: Text('Import Wallet', style: TextStyle(color: Colors.white),)
        ),
      ]
    );
  }
}

import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoWalletScreen extends StatefulWidget {
  NoWalletScreen({Key? key}) : super(key: key);

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
 //   ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: Size(375, 812),
      orientation: Orientation.portrait
    );
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffb5b18c),
            ),
            child: _buildNoWalletBody()
          )
        )
      )
    );
  }

  _buildNoWalletBody() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(height: 100.h,),
        Image.asset('images/mina_logo_white_trans.png', width: 134.w, height: 122.h,),
        Container(height: 26.h,),
        Text('Mina Wallet', textAlign: TextAlign.center, style: TextStyle(fontSize: 28.sp, color: Colors.white)),
        Container(height: 132.h,),
        InkWell(
          onTap: () => Navigator.pushNamed(context, NewWalletAlertRoute, arguments: null),
          child: Container(
            padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 60.w, right: 60.w),
            decoration: getMinaButtonDecoration(topColor: Color(0xffffffff)),
            child: Text('CREATE NEW WALLET',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
          )
        ),
        Container(height: 26.h,),
        InkWell(
          onTap: () => Navigator.pushNamed(context, ImportRecoveryPhraseRoute, arguments: null),
          child: Container(
            padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 64.w, right: 64.w),
            decoration: getMinaButtonDecoration(topColor: Color(0xffd9d9d9)),
            child: Text('RESTORE A WALLET',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
          )
        ),
      ]
    );
  }
}

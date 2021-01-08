import 'package:coda_wallet/receive/screen/receive_account_list.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/types/send_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

_gotoSendFromScreen(BuildContext context) {
  SendData sendData = SendData();
  Navigator.of(context).pushNamed(SendFromRoute, arguments: sendData);
}

class WalletHomeScreen extends StatefulWidget {
  WalletHomeScreen({Key key}) : super(key: key);

  @override
  _WalletHomeScreenState createState() => _WalletHomeScreenState();
}

class _WalletHomeScreenState extends State<WalletHomeScreen> with AutomaticKeepAliveClientMixin {
  bool _stakeEnabled = true;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    return _buildWalletHomeBody(context);
  }

  Widget _buildWalletHomeBody(BuildContext context) {
    if(_stakeEnabled) {
      return _buildStakedHome(context);
    }

    return _buildNoStakeHome();
  }

  _buildStakedHome(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(height: 8.h),
        _buildQRTipIcon(),
        Container(height: 2.h),
        _buildMinaLogo(),
        Container(height: 10.h),
        _buildTotalBalance(),
        _buildFiatBalance(),
        Container(height: 21.h),
        _buildStakedPercent(),
        Container(height: 32.h),
        _buildActionButton(context)
      ]
    );
  }

  _buildNoStakeHome() {
    return Column(children: [
      Expanded(child: Column(
        children: [
          Container(height: 8.h),
          _buildQRTipIcon(),
          Container(height: 2.h),
          _buildMinaLogo(),
          Container(height: 10.h),
          _buildTotalBalance(),
          _buildFiatBalance(),
          Container(height: 12.h),
          _buildActionButton(context)
        ]),
        flex: 5
      ),
      Expanded(child: Container(
        child: Center(
          child: Column(children: [
            Image.asset('images/tx_pending.png', width: 80.w, height: 80.w),
            Container(height: 24.h),
            Text('Earn returns on your hodlings'),
            Container(height: 26.h),
            RaisedButton(
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 70.w, right: 70.w),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
              onPressed: null,
              color: Colors.blueAccent,
              child: Text('Start Staking', style: TextStyle(color: Colors.white),)
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          )),
          color: Colors.white,
        ),
        flex: 4
      )
      ],
    );
  }

  _buildQRTipIcon() {
    return Row(
      children: [
        Expanded(child: Container(), flex: 1),
        Container(
          padding: EdgeInsets.all(10.w),
          width: 44.w,
          height: 44.w,
          child: Image.asset('images/qr_scan1.png')
        ),
        Container(width: 28.w)
      ],
    );
  }

  _buildMinaLogo() {
    return Container(
      width: double.infinity,
      child: Center(
        child: Image.asset('images/mina_logo_inner.png', width: 75.w, height: 75.w,),
      )
    );
  }

  _buildTotalBalance() {
    return Padding(
      padding: EdgeInsets.only(top: 9.h, bottom: 9.h),
      child: Text('123.45 MINA', textAlign: TextAlign.center, style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.normal, color: Colors.black)));
  }

  _buildFiatBalance() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
      child: Text('\$65.34', textAlign: TextAlign.center, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400, color: Color(0xff979797)))
    );
  }

  _buildActionButton(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              child: Text('Send', textAlign: TextAlign.center),
              onTap: () => _gotoSendFromScreen(context),
            )
          ),
          Container(height: 32.67.h, width: 1.w, color: Color(0xffd3d3d3)),
          Expanded(
            flex: 1,
            child: InkWell(
              child: Text('Receive', textAlign: TextAlign.center),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReceiveAccountsScreen())
              ),
            )
          ),
        ],
      ),
      width: 263.w,
      height: 49.h,
      decoration: BoxDecoration(
        color: Color(0xffe6e5eb),
        borderRadius: BorderRadius.all(Radius.circular(9.0))
      ),
      margin: EdgeInsets.all(10),
    );
  }

  _buildStakedPercent() {
    return CircularPercentIndicator(
      radius: 93.w,
      lineWidth: 5.0,
      percent: 0.7,
      center: Text("100%\nSTAKED", textAlign: TextAlign.center,),
      progressColor: Colors.green,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
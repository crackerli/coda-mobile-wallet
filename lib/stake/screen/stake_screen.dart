import 'package:coda_wallet/widget/animation/flip_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StakeScreen extends StatefulWidget {
  StakeScreen({Key key}) : super(key: key);

  @override
  _StakeScreenState createState() => _StakeScreenState();
}

class _StakeScreenState extends State<StakeScreen> {
  bool _stakeEnabled = true;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    return _buildWalletHomeBody();
  }

  Widget _buildWalletHomeBody() {
    if(_stakeEnabled) {
      return _buildStakedHome();
    }

    return _buildNoStakeHome();
  }

  _buildStakedHome() {
    return Column(
      children: [
        Container(height: 52.h),
        Text('You Are Staking!', textAlign: TextAlign.center, style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.normal, color: Colors.black)),
        Container(height: 41.h),
        Text('STAKING RETURNS', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
        Container(height: 2.h),
        AnimatedFlipCounter(
          duration: Duration(milliseconds: 10000),
          value: 2014,
          color: Colors.black,
          size: 100,
        )
      ],
    );
  }

  _buildNoStakeHome() {
    return Container();
  }
}
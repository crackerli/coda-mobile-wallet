import 'package:coda_wallet/widget/animation/flip_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StakeScreen extends StatefulWidget {
  StakeScreen({Key key}) : super(key: key);

  @override
  _StakeScreenState createState() => _StakeScreenState();
}

class _StakeScreenState extends State<StakeScreen> {
  bool _stakeEnabled = true;
  AnimatedFlipCounter _animatedFlipCounter;

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
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(children: [
          Container(height: 52.h),
          Text('You Are Staking!', textAlign: TextAlign.center, style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.normal, color: Colors.black)),
          Container(height: 41.h),
          Text('STAKING RETURNS', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
          Container(height: 19.h),
          AnimatedFlipCounter(
            duration: Duration(milliseconds: 1000),
            value: 12345,
            color: Colors.black,
            size: 50,
          ),
          Container(height: 35.h),
          Container(
            height: 240.h,
            child: _buildStakedList()
          )
        ]),
        Positioned(
          bottom: 35.h,
          child: Column(
            children: [
              RaisedButton(
                padding: EdgeInsets.only(top: 11.h, bottom: 11.h, left: 40.w, right: 40.w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.w))),
                onPressed: null,
                color: Colors.blueAccent,
                child: Text('Stake More Tokens', style: TextStyle(fontSize: 17.sp, color: Colors.white, fontWeight: FontWeight.w600))
              ),
              Container(height: 12.h,),
              RaisedButton(
                padding: EdgeInsets.only(top: 11.h, bottom: 11.h, left: 40.w, right: 40.w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.w))),
                onPressed: null,
                color: Colors.blueAccent,
                child: Text('Change Staking Pool', style: TextStyle(fontSize: 17.sp, color: Colors.white, fontWeight: FontWeight.w600))
              ),
            ],
          )
        )
      ],
    );
  }

  Widget _buildStakedList() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildStakedItem();
      },
      separatorBuilder: (context, index) { return Container(height: 4.h); }
    );
  }

  _buildStakedItem() {
    return Container(
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(10.w),
       color: Colors.white,
       border: Border.all(color: Colors.white, width: 0.5)
      ),
      margin: EdgeInsets.only(left: 18.w, right: 18.w),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Staking Address', textAlign: TextAlign.left, style: TextStyle(fontSize: 17.sp, color: Colors.black)),
              Container(width: 20.w,),
              Text('10,000.00 MINA', textAlign: TextAlign.right, style: TextStyle(fontSize: 17.sp, color: Colors.black))
            ],
          ),
          Container(height: 4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0xa23...efea', textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, color: Color(0xffb1b1b1))),
              Container(width: 20.w,),
              Text('Staking with Sparkpool', textAlign: TextAlign.right, style: TextStyle(fontSize: 13.sp, color: Color(0xff929292)))
            ],
          )
        ]
      ),
    );
  }

  _buildNoStakeHome() {
    return Container();
  }
}
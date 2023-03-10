import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_countdown_timer/index.dart';
import '../../widget/app_bar/app_bar.dart';

const FLEX_LEFT_LABEL = 3;
const FLEX_RIGHT_CONTENT = 10;
const CONTENT_DIVIDER_HEIGHT = 10;

class StakeCenterScreen extends StatefulWidget {
  StakeCenterScreen({Key? key}) : super(key: key);

  @override
  _StakeCenterScreenState createState() => _StakeCenterScreenState();
}


class _StakeCenterScreenState extends State<StakeCenterScreen> with AutomaticKeepAliveClientMixin {
  int endTime = DateTime.now().millisecondsSinceEpoch +
      Duration(seconds: 4000).inMilliseconds;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(context, designSize: const Size(375, 812),
      minTextAdapt: true, splitScreenMode: false, scaleByHeight: false);

    return Column(
      children: [
        buildTitleAppBar(context, 'Stake Center', leading: false, actions: false),
        Container(height: 18.h),
        Text('Congratulations, you are staking', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Color(0xff6bca71)),),
        Container(height: 18.h),
        _buildEpochStatus(context),
        Container(height: 20.h,),
        _buildStakingPager(context)
      ],
    );
  }

  _buildTimerCounter(BuildContext context, int? time) {
    return Container(
      padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
      width: 24.w,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xfff0f0f0), width: 0.5.w),
        borderRadius: BorderRadius.all(Radius.circular(2.w)),
        color: Color(0xffe0e0e0),
      ),
      child: Text('${_formatCountNumber(time)}', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff373737)),),
    );
  }

  _buildEpochStatus(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(18.w, 0, 18.w, 0),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 0.5.w),
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(color: Color(0xfff0f0f0),
            offset: Offset(0, 0), blurRadius: 2, spreadRadius: 2.0)
        ]
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Epoch progress', textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),)
            ],
          ),
          Container(height: CONTENT_DIVIDER_HEIGHT.h),
          Container(height: 1.h, color: Color(0xffeeeef0),),
          Container(height: CONTENT_DIVIDER_HEIGHT.h),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 52.w,
                lineWidth: 5.0,
                percent: 0.5,
                animation: true,
                backgroundColor: Color(0xffbac3df),
                center: Text('10%',
                  style: TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.w600)),
                progressColor: Color(0xff098de6),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Current epoch:', textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Color(0xff979797)),),
                    Container(width: 6.w,),
                    Text('395', textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff373737)),),
                  ],
                ),
                Container(height: CONTENT_DIVIDER_HEIGHT.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Ends in:', textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Color(0xff979797)),),
                    Container(width: 6.w,),
                    CountdownTimer(
                      endTime: endTime,
                      widgetBuilder: (_, CurrentRemainingTime? time) {
                        if (time == null) {
                          return Text('Game over');
                        }
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildTimerCounter(context, time.days),
                            Container(width: 2.w,),
                            Text('d', textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff373737)),),
                            Container(width: 2.w,),
                            _buildTimerCounter(context, time.hours),
                            Container(width: 2.w,),
                            Text(':', textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff373737))),
                            Container(width: 2.w,),
                            _buildTimerCounter(context, time.min),
                            Container(width: 2.w,),
                            Text(':', textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff373737))),
                            Container(width: 2.w,),
                            _buildTimerCounter(context, time.sec),
                          ],
                        );
                      },
                    ),
                  ],
                )
              ],
            )
          ],
        )
      ])
    );
  }

  _buildPartialDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: FLEX_LEFT_LABEL,
          child: Container(),
        ),
        Expanded(
          flex: FLEX_RIGHT_CONTENT,
          child: Container(height: 1.h, color: Color(0xffeeeef0),),
        )
      ],
    );
  }

  _buildStakingDetails(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(2.w, 2.h, 2.w, 2.h),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 0.5.w),
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(color: Color(0xfff0f0f0),
            offset: Offset(0, 0), blurRadius: 2, spreadRadius: 2.0)
        ]
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('Staking details', textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
              Text('Current epoch', textAlign: TextAlign.end,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Color(0xff098de6)),)
            ],
          ),
          Container(height: CONTENT_DIVIDER_HEIGHT.h),
          Container(height: 1.h, color: Color(0xffeeeef0),),
          Container(height: CONTENT_DIVIDER_HEIGHT.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('1245678.12', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
                  Container(height: 6.h,),
                  Text('Amount staked', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff979797)),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('7%', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
                  Container(height: 6.h,),
                  Text('Pool fee', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff979797)),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('18.10%', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff6bc7a1)),),
                  Container(height: 6.h,),
                  Text('Ideal APY', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff979797)),),
                ],
              )
            ],
          ),
          Container(height: CONTENT_DIVIDER_HEIGHT.h),
          Container(height: 1.h, color: Color(0xffeeeef0),),
          Container(height: CONTENT_DIVIDER_HEIGHT.h),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: FLEX_LEFT_LABEL,
                    child: Text('Staking to:', textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
                  ),
                  Expanded(
                    flex: FLEX_RIGHT_CONTENT,
                    child: Text('Minaexplorer', textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
                  )
                ],
              ),
              Container(height: CONTENT_DIVIDER_HEIGHT.h,),
              _buildPartialDivider(context),
              Container(height: CONTENT_DIVIDER_HEIGHT.h,),
              Row(
                children: [
                  Expanded(
                    flex: FLEX_LEFT_LABEL,
                    child: Container(),
                  ),
                  Expanded(
                    flex: FLEX_RIGHT_CONTENT,
                    child: Text('B62qs2Lw5WZNSjd8eHBUZXFYyRjV8oKtrZMFDn1S1Ye62G71xCQJMYM', textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
                  )
                ],
              )
            ],
          )
        ],
      )
    );
  }

  _buildStakingEpoches(BuildContext context) {
    return Expanded(
      child: ExpandablePageView(
        children: <Widget>[
          _buildStakingDetails(context),
          _buildStakingDetails(context)
        ],
      )
    );
  }

  _buildStakingPager(BuildContext context) {
    return Row(
      children: [
        Image.asset('images/left_arrow_triangle.png', width: 16.w, height: 40.h,),
        _buildStakingEpoches(context),
        Image.asset('images/right_arrow_triangle.png', width: 16.w, height: 40.h,),
      ]
    );
  }

  _buildRecentStakedPool(BuildContext context) {

  }

  String _formatCountNumber(int? number) {
    if(null == number) {
      return '00';
    } else {
      if(number < 10) {
        return '0$number';
      } else {
        return number.toString();
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
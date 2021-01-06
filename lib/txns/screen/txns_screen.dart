import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TxnsScreen extends StatefulWidget {
  TxnsScreen({Key key}) : super(key: key);

  @override
  _TxnsScreenState createState() => _TxnsScreenState();
}

class _TxnsScreenState extends State<TxnsScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(height: 10,)
        ),

        Container(height: 2.h,),
        Expanded(
          flex: 10,
          child: _buildTxnList()
        )

      ],
    );
  }

  _buildTxnList() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: _buildTxnItem(),
          onTap: null
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          height: 1.h,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container()
              ),
              Expanded(
                flex: 6,
                child: Container(color: Color(0xffc1c1c1))
              )
            ],
          ),
        );
      },
//      controller: _scrollController
    );
  }

  _buildTxnItem() {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h, bottom: 15.h),
      child: Row(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: <TextSpan>[
            TextSpan(
              text: 'DEC\n',
              style: TextStyle(fontSize: 11.sp, color: Colors.black)),
            TextSpan(
              text: '31',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 20.sp
              )),
          ])),
          Container(width: 20.w,),
          Image.asset('images/txsend.png', height: 40.w, width: 40.w),
          Container(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Sent', textAlign: TextAlign.left, style: TextStyle(fontSize: 14.sp)),
              Text('Pending', textAlign: TextAlign.left, style: TextStyle(fontSize: 14.sp, color: Color(0xffbebebe))),
            ],
          ),
          Container(width: 20.w),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('+1232.45', textAlign: TextAlign.right, style: TextStyle(fontSize: 17.sp)),
                Text('\$65.34', textAlign: TextAlign.right, style: TextStyle(fontSize: 12.sp, color: Color(0xff979797)))
              ]
            ),
          )
        ],
      ),
    );
  }
}
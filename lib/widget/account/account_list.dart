import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

buildAccountList(Function itemTapCallback) {
  return ListView.separated(
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: 6,
    itemBuilder: (context, index) {
      return _buildAccountItem(itemTapCallback);
    },
    separatorBuilder: (context, index) { return Container(height: 10.h); }
  );
}

_buildAccountItem(Function itemTapCallback) {
  return InkWell(
    onTap: itemTapCallback,
    child:
      Container(
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
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: '10,000.00 ',
                    style: TextStyle(fontSize: 17.sp, color: Colors.black)),
                  TextSpan(
                    text: 'MINA',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 12.sp
                    )),
                  ]),
                ),
              ],
            ),
            Container(height: 4.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0xa23...efea', textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, color: Color(0xffb1b1b1))),
                Container(width: 20.w,),
                RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: 'Staking with ',
                      style: TextStyle(fontSize: 13.sp.sp, color: Color(0xff929292))),
                    TextSpan(
                      text: 'Sparkpool',
                      style: TextStyle(
                        color: Color(0xff929292),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp
                    )),
                  ]),
                ),
              ],
            )
          ]
      ),
    )
  );
}
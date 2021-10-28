import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

_getRounded(String text) {
  return Container(
    padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 3.h, bottom: 3.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4.w),
      color: Color(0xfff5f5f5),
      border: Border.all(color: Colors.black, width: 1.w)
    ),
    child: Text(text, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black, fontFeatures: [
      FontFeature.tabularFigures()
    ],)),
  );
}

getTimerWidget(Duration time) {
  return Row(
    children: [
      _getRounded('${time.inDays}'.padLeft(2, '0')),
      Text(' : ', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black)),
      _getRounded('${time.inHours % 24}'.padLeft(2, '0')),
      Text(' : ', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),),
      _getRounded('${time.inMinutes % 60}'.padLeft(2, '0')),
      Text(' : ', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),),
      _getRounded('${time.inSeconds % 60}'.padLeft(2, '0')),
    ],
  );
}
import 'package:coda_wallet/constant/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

buildNoTitleAppBar(BuildContext context, {bool leading = true, bool actions = true, Color backgroundColor = Colors.white}) {
  return PreferredSize(
    child: AppBar(
      actions: [
        InkWell(
          child: Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: actions ? Image.asset('images/close.png', width: 18.w, height: 18.w,) : Container(),
          ),
          onTap: () => Navigator.of(context).pop(),
        )
      ],
      backgroundColor: backgroundColor,
      leadingWidth: 83.w,
      leading: leading ? InkWell(
        child: Row(children: [
          Container(width: 13.w,),
          Image.asset('images/back.png', width: 16.w, height: 22.h,),
          Text('Back', textAlign: TextAlign.left, style: TextStyle(fontSize: 14.sp),)
        ]),
        onTap: () => Navigator.of(context).pop(),
      ) : Container(),
      title: null,
      centerTitle: true,
      elevation: 0,
    ),
    preferredSize: Size.fromHeight(APPBAR_HEIGHT.h)
  );
}
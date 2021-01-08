import 'package:coda_wallet/constant/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

buildNoTitleAppBar(BuildContext context) {
  return PreferredSize(
    child: AppBar(
      backgroundColor: Colors.white,
      leading: InkWell(
        child: Row(children: [
          Image.asset('images/back.png', width: 16.w, height: 22.h,),
          Text('Back', textAlign: TextAlign.left, style: TextStyle(fontSize: 14.sp),)
        ]),
        onTap: () => Navigator.of(context).pop(),
      ),
      title: null,
      centerTitle: true,
      elevation: 0,
    ),
    preferredSize: Size.fromHeight(APPBAR_HEIGHT.h)
  );
}
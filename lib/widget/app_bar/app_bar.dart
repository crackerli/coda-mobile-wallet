import 'package:coda_wallet/constant/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

buildNoTitleAppBar() {
  return PreferredSize(
    child: AppBar(
      title: null,
      centerTitle: true,
      elevation: 0,
    ),
    preferredSize: Size.fromHeight(APPBAR_HEIGHT.h)
  );
}
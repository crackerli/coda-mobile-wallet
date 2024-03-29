import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'common_alert_widget.dart';

void showUnsafeDeviceAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.w))
        ),
        child: CommonAlertWidget(
          'StakingPower wallet detected this device may been rooted or jailbroken, it is an unsafe device.\n' +
          'All operations on this device is not recommended.\n' +
          'Please be sure what you are doing with this device if you want to continue.\n' +
          'Or you\'d better switch to another safe device to use StakingPower wallet.',
          'UNDERSTAND', null)
      );
    }
  );
}
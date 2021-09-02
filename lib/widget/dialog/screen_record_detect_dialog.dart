import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'common_alert_widget.dart';

void showScreenRecordDectectedDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.w))
        ),
        child: CommonAlertWidget(
          'StakingPower wallet detected a screen recording or screenshot while you are staying on the security sensitive page.\n' +
          'If this action is not initiated by yourself, your seed may has been revealed.\n' +
          'Please create another safe wallet on safe device, and move all your tokens to that safe new account',
          'GOT IT', null),
      );
    }
  );
}
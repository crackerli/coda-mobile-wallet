import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'common_alert_widget.dart';

void showUpgradeCihperDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.w))
        ),
        child: CommonAlertWidget(
          'New anti-gpu cipher algorithm was added to encrypt seed.' +
          'It will be default option in future.' +
          'Please upgrade your cipher algorithm to re-encrypt your seed.\n' +
          'Goto \"Settings->Change Password\" to re-encrypt seed, then new cipher text is anti-gpu and can be more safer.',
          'UNDERSTAND', null)
      );
    }
  );
}
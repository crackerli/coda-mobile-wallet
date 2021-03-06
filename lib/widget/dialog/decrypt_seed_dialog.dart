import 'package:coda_wallet/widget/dialog/password_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showDecryptSeedDialog(
  BuildContext context,
  String from
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.w))
        ),
        child: PasswordInputWidget(from)
      );
    }
  );
}
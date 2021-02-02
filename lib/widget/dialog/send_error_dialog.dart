import 'package:coda_wallet/types/send_error_type.dart';
import 'package:coda_wallet/widget/dialog/send_error_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showSendErrorDialog(
  BuildContext context,
  SendErrorType errorType,
  String error
  ) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(1.w)),
        ),
        child: SendErrorWidget(errorType, error)
      );
    }
  );
}
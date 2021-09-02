import 'dart:ui';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/screen_record_detector/screen_record_detector.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/dialog/clipboard_security_alert_dialog.dart';
import 'package:coda_wallet/widget/dialog/screen_record_detect_dialog.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:ffi_mina_signer/sdk/mina_signer_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecoveryPhraseScreen extends StatefulWidget {
  RecoveryPhraseScreen({Key? key}) : super(key: key);

  @override
  _RecoveryPhraseScreenState createState() => _RecoveryPhraseScreenState();
}

class _RecoveryPhraseScreenState extends State<RecoveryPhraseScreen> with ScreenRecordDetector {
  late String _mnemonic;

  @override
  void initState() {
    super.initState();
    super.initDetector();
    _mnemonic = generateMnemonic();
  }

  @override
  void dispose() {
    super.dismissDetector();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: Size(375, 812),
      orientation: Orientation.portrait
    );
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: buildNoTitleAppBar(context, actions: false, backgroundColor: Color(0xfff5f5f5)),
      body: Padding(
        padding: EdgeInsets.only(left: 28.w, right: 28.w),
        child: _buildRecoveryPhraseBody()
      )
    );
  }

  _buildRecoveryPhraseBody() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(children: [
          Image.asset('images/password_unlock_logo.png', width: 100.h, height: 100.h,),
          Container(height: 21.h),
          Text('My Recovery Phrase', style: TextStyle(fontSize: 28.sp, color: Color(0xff2d2d2d))),
          Container(height: 29.h),
          _buildRecoveryPhraseTable(),
          Container(height: 27.h),
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w),
            child: Text('These 12 words are the keys to your wallet.\n\nBack them up manually, or store them in your password manager.',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14.sp, color: Colors.black)),
          ),
          Container(height: 32.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.w),
              color: Color(0xffeeeeee),
              border: Border.all(color: Color(0xffeeeeee), width: 1.w)
            ),
            padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 42.w, right: 42.w),
            child: Builder(builder: (context) =>
              InkWell(
                onTap: () async {
                  bool? copyRet = await showClipboardAlertDialog(context);
                  if(null != copyRet && copyRet) {
                    Clipboard.setData(ClipboardData(text: _mnemonic));
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Recovery phrase copied into clipboard!!')));
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/copy_gray.png', width: 22.w, height: 27.h),
                    Container(width: 6.w,),
                    Text('COPY TO CLIPBOARD', textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
                  ],
                )
              )
            )
          )
        ]),
        Positioned(
          bottom: 67.h,
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed(VerifyRecoveryPhraseRoute, arguments: _mnemonic),
            child: Container(
              padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 100.w, right: 100.w),
              decoration: getMinaButtonDecoration(topColor: Color(0xffe0e0e0)),
              child: Text('CONTINUE',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
            )
          ),
        )
      ],
    );
  }

  Widget _buildRecoveryPhraseTable() {
    List<String> words = _mnemonic.split(' ');

    return Container(
      decoration: BoxDecoration(
        color: Color(0xfffafafa),
        borderRadius: BorderRadius.all(Radius.circular(0.w)),
        border: Border.all(color: Color(0xffd9d9d9), width: 1.w)
      ),
      padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 20.h, bottom: 20.h),
      child: Wrap(
        spacing: 10.w,
        runSpacing: 15.h,
          children: List.generate(words.length, (index) {
            return RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: '${index + 1} ',
                    style: TextStyle(fontSize: 16.sp, color: Color(0xff9e9e9e))),
                  TextSpan(
                    text: '${words[index]}',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16.sp)),
                ]
              )
            );
          }
        )
      )
    );
  }

  @override
  void showWarningAlert() {
    showScreenRecordDectectedDialog(context);
  }
}
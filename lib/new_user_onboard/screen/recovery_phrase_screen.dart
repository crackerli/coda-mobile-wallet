import 'dart:ui';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:ffi_mina_signer/sdk/mina_signer_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecoveryPhraseScreen extends StatefulWidget {
  RecoveryPhraseScreen({Key key}) : super(key: key);

  @override
  _RecoveryPhraseScreenState createState() => _RecoveryPhraseScreenState();
}

class _RecoveryPhraseScreenState extends State<RecoveryPhraseScreen> {
  String _mnemonic;

  @override
  void initState() {
    _mnemonic = generateMnemonic();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildNoTitleAppBar(context, actions: false),
      body: _buildRecoveryPhraseBody()
    );
  }

  _buildRecoveryPhraseBody() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(children: [
          Container(height: 33.h),
          Text('Recovery Phrase', style: TextStyle(fontSize: 25.sp, color: Colors.black, fontWeight: FontWeight.w400)),
          Container(height: 37.h),
          _buildRecoveryPhraseTable(),
          Container(height: 33.h),
          Text('Copy to clipboard', style: TextStyle(fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.w700)),
          Container(height: 33.h),
          Padding(
            padding: EdgeInsets.only(left: 36.w, right: 36.w),
            child: Text('Write these 12 words down, or copy them to a password manager.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.w400)),
            ),
        ]),
        Positioned(
          bottom: 84.h,
          child: RaisedButton(
            padding: EdgeInsets.only(top: 11.h, bottom: 11.h, left: 100.w, right: 100.w),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.w))),
            onPressed: () => Navigator.pushNamed(context, VerifyRecoveryPhraseRoute, arguments: _mnemonic),
            color: Colors.blueAccent,
            child: Text('Continue', style: TextStyle(fontSize: 17.sp, color: Colors.white, fontWeight: FontWeight.w600))
          ),
        )
      ],
    );
  }

  Widget _buildRecoveryPhraseTable() {
    List<String> words = _mnemonic.split(' ');

    return Container(
      margin: EdgeInsets.only(left: 48.w, right: 48.w),
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
      color: Color(0xffededed),
      child: Wrap(
        spacing: 10.w,
        runSpacing: 15.h,
          children: List.generate(words.length, (index) {
            return Text(
              '${words[index]}',
              style: TextStyle(color: Colors.blue, fontSize: 18.sp, fontWeight: FontWeight.w400),
            );
          }
        )
      )
    );
  }
}
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:coda_wallet/util/account_utils.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/dialog/loading_dialog.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:ffi_mina_signer/sdk/mina_signer_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _inputRecoveryPhrasesTip = ' ';

class MnemonicBody {
  String word;
  bool hasFilled;
  void clickCallback() {
    hasFilled = true;
    print('click on $word');
  }
}

class VerifyRecoveryPhraseScreen extends StatefulWidget {
  VerifyRecoveryPhraseScreen({Key key}) : super(key: key);

  @override
  _VerifyRecoveryPhraseScreenState createState() => _VerifyRecoveryPhraseScreenState();
}

class _VerifyRecoveryPhraseScreenState extends State<VerifyRecoveryPhraseScreen> {
  String _mnemonic;
  List<MnemonicBody> _mnemonicTips = List<MnemonicBody>();
  List<String> _mnemonicsFilled = List<String>();
  bool _buttonEnabled = false;

  _verifyWords(BuildContext context) {
    if(_mnemonicsFilled == null || _mnemonicsFilled.isEmpty || _mnemonicsFilled.length < 12) {
      setState(() {
        _buttonEnabled = false;
      });
      return;
    }
    List<String> words = _mnemonic.split(' ');
    for(int i = 0; i < _mnemonicsFilled.length; i++) {
      if(words[i] != _mnemonicsFilled[i]) {
        setState(() {
          _buttonEnabled = false;
        });
        return;
      }
    }

    setState(() {
      _buttonEnabled = true;
    });
    return;
  }

  _createRandomMnemonics() {
    if(null != _mnemonicTips && _mnemonicTips.length > 0) {
      return;
    }
    List<String> words = _mnemonic.split(' ');
    words.shuffle();
    for(int i = 0; i < words.length; i++) {
      MnemonicBody body = MnemonicBody();
      body.hasFilled = false;
      body.word = words[i];
      _mnemonicTips.add(body);
    }
  }

  _clearInputWords() {
    for(int i = 0; i < _mnemonicTips.length; i++) {
      MnemonicBody body = _mnemonicTips[i];
      body.hasFilled = false;
    }

    _mnemonicsFilled.clear();
    _mnemonicsFilled.add(_inputRecoveryPhrasesTip);
    setState(() {
      _buttonEnabled = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _mnemonicsFilled.add(_inputRecoveryPhrasesTip);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    _mnemonic = ModalRoute.of(context).settings.arguments;
    _createRandomMnemonics();
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: buildNoTitleAppBar(context, actions: false, backgroundColor: Color(0xfff5f5f5)),
      body: _buildRecoveryPhraseBody()
    );
  }

  _buildRecoveryPhraseBody() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(children: [
          Image.asset('images/password_unlock_logo.png', width: 100.h, height: 100.h,),
          Container(height: 20.h,),
          Text('Select the words in the correct order', style: TextStyle(fontSize: 18.sp, color: Colors.black)),
          Container(height: 20.h),
          _buildRecoveryPhraseFilledTable(),
          Container(height: 20.h),
          _buildRecoveryPhraseTipTable(),
          Container(height: 19.h),
          InkWell(
            onTap: _clearInputWords,
            child: Container(
              padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 100.w, right: 100.w),
              decoration: getMinaButtonDecoration(topColor: Color(0xffeeeeee)),
              child: Text('CLEAR',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
            )
          ),
        ]),
        _buttonEnabled ? Positioned(
          bottom: 84.h,
          child: Builder(builder: (context) =>
            InkWell(
              onTap: () => Navigator.pushNamed(context, EncryptSeedRoute, arguments: _mnemonic),
              child: Container(
                padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 100.w, right: 100.w),
                decoration: getMinaButtonDecoration(topColor: Color(0xff9fe4c9)),
                child: Text('CONTINUE',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
              )
            )
        )) : Container()
      ],
    );
  }

  Widget _buildRecoveryPhraseFilledTable() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 14.sp * 7 + 10.h,
        minWidth: double.infinity
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xfffafafa),
          borderRadius: BorderRadius.all(Radius.circular(1.w)),
          border: Border.all(color: Color(0xffd9d9d9), width: 1.w)
        ),
        margin: EdgeInsets.only(left: 24.w, right: 24.w),
        padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
        child: Wrap(
          spacing: 10.w,
          runSpacing: 15.h,
          children: List.generate(_mnemonicsFilled.length, (index) {
          return Text(
            '${_mnemonicsFilled[index]}',
            style: TextStyle(color: Colors.black, fontSize: 16.sp),
          );
        }
      ))
    ));
  }

  Widget _buildRecoveryPhraseTipTable() {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w),
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
      color: Colors.white,
      child: Wrap(
        spacing: 10.w,
        runSpacing: 15.h,
        children: List.generate(_mnemonicTips.length, (index) {
          return InkWell(
            child: Container(
              padding: EdgeInsets.only(top: 3.96.h, bottom: 3.96.h, left: 10.w, right: 10.w),
              child: Text('${_mnemonicTips[index].word}',
                style: TextStyle(fontSize: 16.sp,
                  color: _mnemonicTips[index].hasFilled ? Colors.transparent : Colors.black,
                  fontWeight: FontWeight.normal)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.w),
                color: _mnemonicTips[index].hasFilled ? Colors.transparent : Colors.white,
                border: Border.all(color: Color(0xffd9d9d9), width: 1.w)
              ),
            ),
            onTap: _mnemonicTips[index].hasFilled ? null: () {
              _mnemonicTips[index].hasFilled = true;
              if(_mnemonicsFilled.length == 1 && _mnemonicsFilled[0] == _inputRecoveryPhrasesTip) {
                _mnemonicsFilled[0] = _mnemonicTips[index].word;
              } else {
                _mnemonicsFilled.add(_mnemonicTips[index].word);
              }
              _verifyWords(context);
            },
          );
        })
      )
    );
  }

}
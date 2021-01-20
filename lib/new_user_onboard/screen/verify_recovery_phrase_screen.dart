import 'dart:typed_data';
import 'dart:ui';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:ffi_mina_signer/sdk/mina_signer_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _inputRecoveryPhrasesTip = 'Please input the recovery phrases here';

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

  bool _verifyWords() {
    List<String> words = _mnemonic.split(' ');
    for(int i = 0; i < _mnemonicsFilled.length; i++) {
      if(words[i] != _mnemonicsFilled[i]) {
        return false;
      }
    }
    return true;
  }

  _handleSeed(BuildContext context) async {
    bool verifyRet = _verifyWords();
    if(verifyRet) {
      Uint8List seed = await mnemonicToSeed(_mnemonic.toString());
      globalPreferences.setString(ENCRYPTED_SEED_KEY, encryptSeed(seed, '1234'));
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Wrong input words')));
    }
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
      backgroundColor: Colors.white,
      appBar: buildNoTitleAppBar(context),
      body: _buildRecoveryPhraseBody()
    );
  }

  _buildRecoveryPhraseBody() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(children: [
          Container(height: 33.h),
          Text('Verify Recovery Phrase', style: TextStyle(fontSize: 25.sp, color: Colors.black, fontWeight: FontWeight.w400)),
          Container(height: 37.h),
          _buildRecoveryPhraseFilledTable(),
          Container(height: 19.h),
          _buildRecoveryPhraseTipTable(),
          Container(height: 19.h),
          RaisedButton(
            padding: EdgeInsets.only(top: 11.h, bottom: 11.h, left: 100.w, right: 100.w),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.w))),
            onPressed: _clearInputWords,
            color: Colors.blueAccent,
            child: Text('Clear', style: TextStyle(fontSize: 17.sp, color: Colors.white, fontWeight: FontWeight.w600))
          ),
        ]),
        Positioned(
          bottom: 84.h,
          child: Builder(builder: (context) =>
          RaisedButton(
            padding: EdgeInsets.only(top: 11.h, bottom: 11.h, left: 100.w, right: 100.w),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.w))),
            onPressed: () => _handleSeed(context),
            color: Colors.blueAccent,
            child: Text('Continue', style: TextStyle(fontSize: 17.sp, color: Colors.white, fontWeight: FontWeight.w600))
          ),
        ))
      ],
    );
  }

  Widget _buildRecoveryPhraseFilledTable() {
    return Container(
      margin: EdgeInsets.only(left: 48.w, right: 48.w),
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
      color: Colors.white,
      child: Wrap(
        spacing: 10.w,
        runSpacing: 15.h,
        children: List.generate(_mnemonicsFilled.length, (index) {
          return Text(
            '${_mnemonicsFilled[index]}',
            style: TextStyle(color: Colors.blue, fontSize: 18.sp, fontWeight: FontWeight.w400),
          );}
        )
      )
    );
  }

  Widget _buildRecoveryPhraseTipTable() {
    return Container(
      margin: EdgeInsets.only(left: 30.w, right: 30.w),
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
      color: Colors.white,
      child: Wrap(
        spacing: 10.w,
        runSpacing: 15.h,
        children: List.generate(_mnemonicTips.length, (index) {
          return GestureDetector(
            child: Container(
              padding: EdgeInsets.only(top: 3.96.h, bottom: 3.96.h, left: 10.w, right: 10.w),
              child: Text('${_mnemonicTips[index].word}',
                style: TextStyle(fontSize: 16.sp,
                  color: _mnemonicTips[index].hasFilled ? Colors.transparent : Colors.white,
                  fontWeight: FontWeight.normal)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.w),
                color: _mnemonicTips[index].hasFilled ? Colors.transparent : Colors.blue,
                border: Border.all(color: Colors.blue, width: 0.5)
              ),
            ),
            onTap: _mnemonicTips[index].hasFilled ? null: () {
              _mnemonicTips[index].hasFilled = true;
              if(_mnemonicsFilled.length == 1 && _mnemonicsFilled[0] == _inputRecoveryPhrasesTip) {
                _mnemonicsFilled[0] = _mnemonicTips[index].word;
              } else {
                _mnemonicsFilled.add(_mnemonicTips[index].word);
              }
              setState(() {
              });
            },
          );
        })
      )
    );
  }

}
import 'dart:ui';

import 'package:coda_wallet/global/global.dart';
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
  List<MnemonicBody> _mnemonicTips = List<MnemonicBody>();
  List<String> _mnemonicsFilled = List<String>();
  
  _createRandomMnemonics() {
    List<String> words = globalMnemonic.split(' ');
    print('---------------- $words -------------------');
    words.shuffle();
    print('================ $words ===================');
    for(int i = 0; i < words.length; i++) {
      MnemonicBody body = MnemonicBody();
      body.hasFilled = false;
      body.word = words[i];
      _mnemonicTips.add(body);
    }
  }

  @override
  void initState() {
    super.initState();
    _createRandomMnemonics();
    _mnemonicsFilled.add(_inputRecoveryPhrasesTip);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    return Scaffold(
      backgroundColor: Color(0xffeeeeee),
      appBar: _buildSettingAppBar(),
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
        ]),
        Positioned(
          bottom: 84.h,
          child: RaisedButton(
            padding: EdgeInsets.only(top: 11.h, bottom: 11.h, left: 100.w, right: 100.w),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.w))),
            onPressed: null,
            color: Colors.blueAccent,
            child: Text('Continue', style: TextStyle(fontSize: 17.sp, color: Colors.white, fontWeight: FontWeight.w600))
          ),
        )
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

  _clickWordTofill() {

  }

  Widget _buildSettingAppBar() {
    return PreferredSize(
      child: AppBar(
        title: Text('Setting',
          style: TextStyle(fontSize: 17.sp, color: Colors.black, fontWeight: FontWeight.w400)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      preferredSize: Size.fromHeight(52.h)
    );
  }

}
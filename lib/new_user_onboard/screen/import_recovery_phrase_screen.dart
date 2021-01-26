import 'dart:ui';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:ffi_mina_signer/sdk/mina_signer_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class ImportRecoveryPhraseScreen extends StatefulWidget {
  ImportRecoveryPhraseScreen({Key key}) : super(key: key);

  @override
  _ImportRecoveryPhraseScreenState createState() => _ImportRecoveryPhraseScreenState();
}

class _ImportRecoveryPhraseScreenState extends State<ImportRecoveryPhraseScreen> {
  FocusNode _focusNode;
  TextEditingController _editingController;
  String _mnemonic;
  bool _inputValidated = false;

  bool _validateWords() {
    if(_editingController.text.isEmpty) {
      return false;
    }
    
    List<String> wordsList = _getInputWords(_editingController.text);

    if(wordsList.length >= 12) {
      return true;
    }

    return false;
  }
  
  List<String> _getInputWords(String input) {
    if(null == input || input.isEmpty) {
      return null;
    }

    List<String> tmp = input.trim().split(' ');
    tmp.remove("");
    List<String> mnemonicList = List<String>();
    for(int i = 0; i < tmp.length; i++) {
      if(tmp[i] != '') {
        mnemonicList.add(tmp[i].trim());
      }
    }

    return mnemonicList;
  }

  _checkMnemonic(BuildContext context) {
    if(_editingController.text.isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Invalid recovery phrase!!')));
    }
    List<String> wordsList = _getInputWords(_editingController.text);
    if(null == wordsList || wordsList.length < 12) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Invalid recovery phrase!!')));
    }

    _mnemonic = wordsList.join(' ');
    //   _mnemonic = 'course grief vintage slim tell hospital car maze model style elegant kitchen state purpose matrix gas grid enable frown road goddess glove canyon key';
    bool validateRet = validateMnemonic(_mnemonic);
    if(!validateRet) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Can not find any accounts under this seed!!')));
      return;
    } else {
      Navigator.pushNamed(context, EncryptSeedRoute, arguments: _mnemonic);
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _editingController = TextEditingController();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _editingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: buildNoTitleAppBar(context, actions: false, backgroundColor: Color(0xfff5f5f5)),
      body: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w),
        child: KeyboardActions(
          tapOutsideToDismiss: true,
          autoScroll: true,
          config: KeyboardActionsConfig(
          keyboardSeparatorColor: Colors.grey,
          nextFocus: false,
          actions: [ KeyboardActionsItem(focusNode: _focusNode) ]),
          child: SingleChildScrollView(
            child: _buildImportRecoveryPhraseBody(context)
          )
      ))
    );
  }

  _buildImportRecoveryPhraseBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(height: 37.h,),
        Text('Enter Recovery Phrase', textAlign: TextAlign.left, style: TextStyle(fontSize: 28.sp, color: Color(0xff2d2d2d)),),
        Container(height: 16.h,),
        Text('This is a 12 word phrase you were given when you created your previous wallet', textAlign: TextAlign.left,
          style: TextStyle(fontSize: 16.sp), maxLines: 3,),
        Container(height: 40.h,),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 16.sp * 6 + 20.h,
          ),
          child: Container(
            margin: EdgeInsets.only(left: 0.w, right: 0.w, top: 16.h, bottom: 16.h),
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 16.h, bottom: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.w),
              shape: BoxShape.rectangle,
              border: Border.all(width: 1.0, color: Color(0xff757575),),
            ),
            child: TextField(
              enableInteractiveSelection: true,
              focusNode: _focusNode,
              controller: _editingController,
              onChanged: (text) {
                bool ret = _validateWords();
                setState(() {
                  _inputValidated = ret;
                });
              },
              maxLines: null,
              keyboardType: TextInputType.multiline,
              autofocus: false,
              decoration: InputDecoration.collapsed(
                hintText: 'Recovery Phrase',
                hintStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal, color: Color(0x4d2d2d2d)))
              )
          )
        ),
        Container(height: 25.h,),
        Builder(
          builder: (context) =>
            Center(child:
            InkWell(
              onTap: _inputValidated ? () => _checkMnemonic(context) : null,
              child: Container(
                padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 100.w, right: 100.w),
                decoration: getMinaButtonDecoration(topColor: Color(_inputValidated ? 0xffeeeeee : 0x4deeeeee)),
                child: Text('NEXT',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(_inputValidated ? 0xff2d2d2d : 0x4d2d2d2d))),
              )
            ),
        ))
      ],
    );
  }
}
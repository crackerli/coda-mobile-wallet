import 'dart:ui';
import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/test/test_data.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:coda_wallet/util/account_utils.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/dialog/loading_dialog.dart';
import 'package:ffi_mina_signer/sdk/mina_signer_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImportRecoveryPhraseScreen extends StatefulWidget {
  ImportRecoveryPhraseScreen({Key key}) : super(key: key);

  @override
  _ImportRecoveryPhraseScreenState createState() => _ImportRecoveryPhraseScreenState();
}

class _ImportRecoveryPhraseScreenState extends State<ImportRecoveryPhraseScreen> {
  FocusNode _focusNode;
  TextEditingController _editingController;
  String _mnemonic;

  _processMnemonicWords(BuildContext context) async {
    if(_editingController.text.isEmpty) {
      return;
    }

    List<String> tmp = _editingController.text.trim().split(' ');
    tmp.remove("");
    List<String> mnemonicList = List<String>();
    for(int i = 0; i < tmp.length; i++) {
      if(tmp[i] != '') {
        mnemonicList.add(tmp[i].trim());
      }
    }
 //   _mnemonic = mnemonicList.join(' ');
    _mnemonic = 'course grief vintage slim tell hospital car maze model style elegant kitchen state purpose matrix gas grid enable frown road goddess glove canyon key';
    globalPreferences.setString(ENCRYPTED_SEED_KEY, encryptSeed(mnemonicToSeed(_mnemonic.toString()), '1234'));
    ProgressDialog.showProgress(context);
    List<MinaHDAccount> accounts = await deriveDefaultAccount(mnemonicToSeed(_mnemonic));
    testAccounts.clear();
    testAccounts.addAll(accounts);
    ProgressDialog.dismiss(context);
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _editingController = TextEditingController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildNoTitleAppBar(context, actions: false),
      body: _buildImportRecoveryPhraseBody(context)
    );
  }

  _buildImportRecoveryPhraseBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text('Please input the recovery phrase'),
        Container(height: 16.h,),
        Container(
          margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 16.h, bottom: 16.h),
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 16.h, bottom: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            shape: BoxShape.rectangle,
            border: Border.all(width: 1.0, color: Colors.grey,),
          ),
          child: TextField(
            enableInteractiveSelection: true,
            focusNode: _focusNode,
            controller: _editingController,
            onChanged: null,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            autofocus: false,
            decoration: InputDecoration.collapsed(
            hintText: 'Input recovery phrase',
            hintStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal, color: Color(0xffbdbdbd)))
          )
        ),
        Container(height: 16.h,),
        RaisedButton(
          padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 80, right: 80),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
          onPressed: () {
            _focusNode.unfocus();
            _processMnemonicWords(context);
          },
          color: Colors.blueAccent,
          child: Text('Import', style: TextStyle(color: Colors.white),)
        )
      ],
    );
  }
}
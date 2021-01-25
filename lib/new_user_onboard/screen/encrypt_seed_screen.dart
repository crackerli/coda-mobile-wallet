import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/global/global.dart';
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
import 'package:keyboard_actions/keyboard_actions.dart';

class EncryptSeedScreen extends StatefulWidget {
  EncryptSeedScreen({Key key}) : super(key: key);

  @override
  _EncryptSeedScreenState createState() => _EncryptSeedScreenState();
}

class _EncryptSeedScreenState extends State<EncryptSeedScreen> {
  FocusNode _focusNode;
  TextEditingController _editingController;
  String _mnemonic;
  bool _inputValidated = false;

  bool _validateWords() {
    if(_editingController.text.isEmpty) {
      return false;
    }

    List<String> tmp = _editingController.text.trim().split(' ');
    tmp.remove("");
    List<String> mnemonicList = List<String>();
    for(int i = 0; i < tmp.length; i++) {
      if(tmp[i] != '') {
        mnemonicList.add(tmp[i].trim());
      }
    }

    if(mnemonicList.length >= 12) {
      return true;
    }

    return false;
  }

  // bool _validateMnemonic() {
  //   if(!_validateWords()) {
  //     return false;
  //   }
  //
  //   _mnemonic = mnemonicList.join(' ');
  //   //   _mnemonic = 'course grief vintage slim tell hospital car maze model style elegant kitchen state purpose matrix gas grid enable frown road goddess glove canyon key';
  //   bool validateRet = validateMnemonic(_mnemonic);
  //   if(!validateRet) {
  //     Scaffold.of(context).showSnackBar(SnackBar(content: Text('Can not find any accounts under this seed!!')));
  //     return false;
  //   }
  // }

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
    _mnemonic = mnemonicList.join(' ');
    //   _mnemonic = 'course grief vintage slim tell hospital car maze model style elegant kitchen state purpose matrix gas grid enable frown road goddess glove canyon key';
    bool validateRet = validateMnemonic(_mnemonic);
    if(!validateRet) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Can not find any accounts under this seed!!')));
      return;
    }
    print('[import wallet]: start convert mnemonic words to seed');
    ProgressDialog.showProgress(context);
    Uint8List seed = await mnemonicToSeed(_mnemonic.toString());
    print('[import wallet]: start to encrypted seed');
    globalEncryptedSeed = encryptSeed(seed, '1234');
    print('[import wallet]: save seed String');
    globalPreferences.setString(ENCRYPTED_SEED_KEY, globalEncryptedSeed);

    print('[import wallet]: start to derive account');
    List<AccountBean> accounts = await deriveDefaultAccount(seed);
    globalHDAccounts.accounts = accounts;
    Map accountsJson = globalHDAccounts.toJson();
    globalPreferences.setString(GLOBAL_ACCOUNTS_KEY, json.encode(accountsJson));
    ProgressDialog.dismiss(context);
    Navigator.popUntil(context, (route) => route.isFirst);
    eventBus.fire(UpdateAccounts());
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
      backgroundColor: Color(0xfff5f5f5),
        appBar: buildNoTitleAppBar(context, actions: false),
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
            )
        )
    );
  }

  _buildImportRecoveryPhraseBody(BuildContext context) {
    return Text('Encrypt Seed');
  }
}
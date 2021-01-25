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
  FocusNode _focusNodeOrigin;
  FocusNode _focusNodeConfirm;
  TextEditingController _controllerOrigin;
  TextEditingController _controllerConfirm;
  bool _showOrigin = false;
  bool _showConfirm = false;
  String _mnemonic;
  bool _inputValidated = false;

  _checkPassword(BuildContext context) {}

  _processMnemonicWords(BuildContext context) async {
    // if(_editingController.text.isEmpty) {
    //   return;
    // }
    //
    // List<String> tmp = _editingController.text.trim().split(' ');
    // tmp.remove("");
    // List<String> mnemonicList = List<String>();
    // for(int i = 0; i < tmp.length; i++) {
    //   if(tmp[i] != '') {
    //     mnemonicList.add(tmp[i].trim());
    //   }
    // }
    //_mnemonic = mnemonicList.join(' ');
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
    _focusNodeOrigin = FocusNode();
    _focusNodeConfirm = FocusNode();
    _controllerOrigin = TextEditingController();
    _controllerConfirm = TextEditingController();
  }

  @override
  void dispose() {
    _focusNodeOrigin?.dispose();
    _focusNodeConfirm?.dispose();
    _controllerOrigin?.dispose();
    _controllerConfirm?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    _mnemonic = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: buildNoTitleAppBar(context, actions: false, backgroundColor: Color(0xfff5f5f5)),
      body: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w),
        child: KeyboardActions(
          tapOutsideToDismiss: true,
          autoScroll: true,
          config: KeyboardActionsConfig(
            keyboardSeparatorColor: Colors.grey,
            nextFocus: false,
            actions: [
              KeyboardActionsItem(focusNode: _focusNodeOrigin),
              KeyboardActionsItem(focusNode: _focusNodeConfirm)
            ]),
            child: SingleChildScrollView(
              child: _buildCreatePasswordBody(context)
            )
          )
        )
    );
  }

  _buildCreatePasswordBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(height: 37.h,),
        Text('Create Password', textAlign: TextAlign.left, style: TextStyle(fontSize: 28.sp, color: Color(0xff2d2d2d)),),
        Container(height: 26.h,),
        Container(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h, bottom: 15.h),
        child: Row(children: [
          Container(width: 8,),
          Expanded(
            flex: 1,
            child: TextField(
              enableInteractiveSelection: true,
              focusNode: _focusNodeOrigin,
              controller: _controllerOrigin,
              onChanged: (text) {

              },
              maxLines: 1,
              obscureText: _showOrigin ? false : true,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: InputDecoration.collapsed(
                hintText: 'Please input seed password',
                hintStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal, color: Color(0xffbdbdbd)))
            )
          ),
          Container(width: 4.w,),
          InkWell(
            onTap: () {
              setState(() {
                _showOrigin = !_showOrigin;
              });
            },
            child: _showOrigin ? Image.asset('images/password_show.png', width: 20.w, height: 20.w,)
              : Image.asset('images/password_hide.png', width: 20.w, height: 20.w,),
          ),
          Container(width: 8.w,)]),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(2.w)),
            border: Border.all(width: 1.w, color: Color(0xff757575))
          )
        ),
        Container(height: 12.h,),
        Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h, bottom: 15.h),
          child: Row(children: [
            Container(width: 8,),
            Expanded(
              flex: 1,
              child: TextField(
                enableInteractiveSelection: true,
                focusNode: _focusNodeConfirm,
                controller: _controllerConfirm,
                onChanged: (text) {

                },
                maxLines: 1,
                obscureText: _showConfirm ? false : true,
                keyboardType: TextInputType.text,
                autofocus: false,
                decoration: InputDecoration.collapsed(
                  hintText: 'Please input seed password',
                  hintStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal, color: Color(0xffbdbdbd)))
                )
              ),
              Container(width: 4.w,),
              InkWell(
                onTap: () {
                  setState(() {
                    _showConfirm = !_showConfirm;
                  });
                },
                child: _showConfirm ? Image.asset('images/password_show.png', width: 20.w, height: 20.w,)
                  : Image.asset('images/password_hide.png', width: 20.w, height: 20.w,),
              ),
              Container(width: 8.w,),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(2.w)),
            border: Border.all(width: 1.w, color: Color(0xff757575))
          ),
        ),
        Container(height: 28.h,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset('images/security_alert_blue.png', width: 28.w, height: 28.w,),
            Container(width: 14.w,),
            Flexible(
              child: Text('I understand that if I lose my password, I will not be able to access my funds.',
                textAlign: TextAlign.left, maxLines: 3, style: TextStyle(fontSize: 16.sp),)
            )
          ],
        ),
        Container(height: 34.h,),
        Builder(builder: (context) =>
          Center(child:
            InkWell(
              onTap: _inputValidated ? () => _checkPassword(context) : null,
              child: Container(
                padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 100.w, right: 100.w),
                decoration: getMinaButtonDecoration(topColor: Color(_inputValidated ? 0xffeeeeee : 0x4deeeeee)),
                child: Text('NEXT',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(_inputValidated ? 0xff2d2d2d : 0x4d2d2d2d))),
              )
            ),
          )
        )
      ],
    );
  }
}
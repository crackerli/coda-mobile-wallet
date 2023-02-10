import 'dart:convert';
import 'dart:typed_data';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:coda_wallet/util/account_utils.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/dialog/decrypt_seed_dialog.dart';
import 'package:coda_wallet/widget/dialog/loading_dialog.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:ffi_mina_signer/sdk/mina_signer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class CreateAccountScreen extends StatefulWidget {
  CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  FocusNode _focusNodeAccount = FocusNode();
  TextEditingController _accountController = TextEditingController();
  var _eventBusOn;

  @override
  void initState() {
    super.initState();
    _eventBusOn = eventBus.on<NewAccountPasswordInput>().listen((event) {
      _deriveNewAccount(event.password);
    });
  }

  @override
  void dispose() {
    _eventBusOn.cancel();
    _eventBusOn = null;
    _focusNodeAccount.dispose();
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true, splitScreenMode: false, scaleByHeight: false);
    print('CreateAccountScreen: build(context: $context)');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffffffff),
      appBar: buildNoTitleAppBar(context, actions: false, backgroundColor: Color(0xffffffff)),
      body: KeyboardActions(
        tapOutsideToDismiss: true,
        autoScroll: true,
        config: KeyboardActionsConfig(
        keyboardSeparatorColor: Colors.grey,
        nextFocus: false,
        actions: [ KeyboardActionsItem(focusNode: _focusNodeAccount) ]),
        child: SingleChildScrollView(
          child: _buildCreateAccountBody(context),
        )
      )
    );
  }

  _buildCreateAccountBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(height: 30.h),
        Padding(
          padding: EdgeInsets.only(left: 29.w, right: 29.w),
          child: Text('Create New Account', textAlign: TextAlign.left, style: TextStyle(fontSize: 28.sp, color: Color(0xff2d2d2d)),),
        ),
        Container(height: 36.h),
        Padding(
          padding: EdgeInsets.only(left: 29.w, right: 29.w),
          child: Text('NAME YOUR ACCOUNT', textAlign: TextAlign.left,
            style: TextStyle(fontSize: 13.sp, color: Color(0xff616161), fontWeight: FontWeight.w500)),
        ),
        Container(height: 9.h),
        Padding(
          padding: EdgeInsets.only(left: 29.w, right: 29.w),
          child: _buildAccountField(context),
        ),
        Container(height: 23.h,),
        Center(
          child: InkWell(
          onTap: () => showDecryptSeedDialog(context, CreateAccountRoute),//_deriveNewAccount(context),
          child: Container(
            padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 100.w, right: 100.w),
            decoration: getMinaButtonDecoration(topColor: Color(0xffeeeeee)),
            child: Text('CREATE',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
          ),
        ))
      ],
    );
  }

  _buildAccountField(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15.w, right: 10.w, top: 14.h, bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(0.w)),
        border: Border.all(color: Color(0xff757575), width: 1.w)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Expanded(
          flex: 1,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            enableInteractiveSelection: true,
            focusNode: _focusNodeAccount,
            controller: _accountController,
            onChanged: (text) {

            },
            maxLines: null,
            keyboardType: TextInputType.multiline,
            autofocus: false,
            decoration: InputDecoration.collapsed(
              hintText: 'Account #${globalHDAccounts.accounts!.length}',
              hintStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal, color: Color(0xffbdbdbd)))
            )
          ),
          Container(width: 12.w),
          InkWell(
            child: Container(
              padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 4.w, right: 4.w),
              child: Image.asset('images/input_delete.png', width: 18.w, height: 18.w),
            ),
            onTap: () {
              setState(() {
                _accountController.text = '';
              }
            );},
          )
        ],
      ),
    );
  }

  _deriveNewAccount(String password) async {
    Uint8List seed;
    ProgressDialog.showProgress(context);
    try {
      seed = await decryptSeed(globalEncryptedSeed!, password);
    } catch(error) {
      print('password not right');
      ProgressDialog.dismiss(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong password')));
      return;
    } finally { }
    String accountName = '';
    if(_accountController.text.isEmpty) {
      accountName = 'Account #${globalHDAccounts.accounts!.length}';
    } else {
      accountName = _accountController.text;
    }
    AccountBean account = await deriveNewAccount(seed, globalHDAccounts.accounts!.length, accountName);
    globalHDAccounts.accounts!.add(account);
    Map accountsJson = globalHDAccounts.toJson();
//    globalPreferences.setString(GLOBAL_ACCOUNTS_KEY, json.encode(accountsJson));
    await globalSecureStorage.write(key: GLOBAL_ACCOUNTS_KEY, value: json.encode(accountsJson));
    ProgressDialog.dismiss(context);
    Navigator.of(context).pop();
    eventBus.fire(UpdateMyAccounts());
  }
}

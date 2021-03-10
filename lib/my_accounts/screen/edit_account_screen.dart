import 'dart:convert';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class EditAccountScreen extends StatefulWidget {
  EditAccountScreen({Key key}) : super(key: key);

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  FocusNode _focusNodeAccount = FocusNode();
  TextEditingController _accountController = TextEditingController();
  int _accountIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNodeAccount?.dispose();
    _accountController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    print('CreateAccountScreen: build(context: $context)');
    _accountIndex = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff5f5f5),
      appBar: buildNoTitleAppBar(context, actions: false, backgroundColor: Color(0xfff5f5f5)),
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
          child: Text('Edit Account Name', textAlign: TextAlign.left, style: TextStyle(fontSize: 28.sp, color: Color(0xff2d2d2d)),),
        ),
        Container(height: 36.h),
        Padding(
          padding: EdgeInsets.only(left: 29.w, right: 29.w),
          child: Text('RENAME YOUR ACCOUNT', textAlign: TextAlign.left,
            style: TextStyle(fontSize: 13.sp, color: Color(0xff616161), fontWeight: FontWeight.w500)),
        ),
        Container(height: 9.h),
        Padding(
          padding: EdgeInsets.only(left: 29.w, right: 29.w),
          child: _buildAccountField(context),
        ),
        Container(height: 19.h,),
        Center(
          child: InkWell(
            onTap: () => _saveNewAccount(context),
            child: Container(
              padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 120.w, right: 120.w),
              decoration: getMinaButtonDecoration(topColor: Color(0xffeeeeee)),
              child: Text('SAVE',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
            ),
          )
        )
      ],
    );
  }

  _buildAccountField(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15.w, right: 10.w, top: 8.h, bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(0.w)),
        border: Border.all(color: Color(0xff757575), width: 1.w)
      ),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: TextField(
            enableInteractiveSelection: true,
            focusNode: _focusNodeAccount,
            controller: _accountController,
            onChanged: (text) {

            },
            maxLines: null,
            keyboardType: TextInputType.multiline,
            autofocus: false,
            decoration: InputDecoration.collapsed(
              hintText: globalHDAccounts.accounts[_accountIndex].accountName,
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

  _saveNewAccount(BuildContext context) {
    if(null == globalHDAccounts || null == globalHDAccounts.accounts || 0 == globalHDAccounts.accounts.length) {
      return;
    }

    if(null == _accountController.text || _accountController.text.isEmpty) {
      return;
    }

    AccountBean account = globalHDAccounts.accounts[_accountIndex];
    account.accountName = _accountController.text;
    Map accountsJson = globalHDAccounts.toJson();
    globalPreferences.setString(GLOBAL_ACCOUNTS_KEY, json.encode(accountsJson));
    Navigator.of(context).pop();
    eventBus.fire(UpdateMyAccounts());
  }
}

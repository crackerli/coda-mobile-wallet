import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class PasswordInputWidget extends StatefulWidget {
  String _from;
  PasswordInputWidget(this._from, {Key key}) : super(key: key);

  @override
  _PasswordInputWidgetState createState() => _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends State<PasswordInputWidget> {
  FocusNode _focusNodePassword = FocusNode();
  TextEditingController _editingControllerPassword = TextEditingController();
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNodePassword?.dispose();
    _editingControllerPassword?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    print('PasswordInputWidget: build(context: $context)');
    return KeyboardActions(
      tapOutsideToDismiss: false,
      autoScroll: false,
      disableScroll: true,
      config: KeyboardActionsConfig(
        keyboardSeparatorColor: Colors.grey,
        nextFocus: false,
        actions: [
          KeyboardActionsItem(focusNode: _focusNodePassword)
        ]
      ),
      child: Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
        color: Colors.white
      ),
      padding: EdgeInsets.only(top: 12.h, bottom: 12.h, left: 12.w, right: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset('images/password_unlock_logo.png', width: 40.w, height: 40.w,),
          Container(height: 12.h,),
          Text('PLEASE INPUT PASSWORD', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontSize: 14.sp),),
          Container(height: 12,),
          Container(
            padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
            child: Row(
              children: [
                Container(width: 8,),
                Expanded(
                  flex: 1,
                  child: TextField(
                    enableInteractiveSelection: true,
                    focusNode: _focusNodePassword,
                    controller: _editingControllerPassword,
                    onChanged: (text) {

                    },
                    maxLines: 1,
                    obscureText: _showPassword ? false : true,
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
                      _showPassword = !_showPassword;
                    });
                  },
                  child: _showPassword ? Image.asset('images/pwd_show.png', width: 20.w, height: 20.w,)
                    : Image.asset('images/pwd_hide.png', width: 20.w, height: 20.w,),
                ),
                Container(width: 8.w,),
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xfff5f5f5),
              borderRadius: BorderRadius.all(Radius.circular(5.w)),
              border: Border.all(width: 1.w, color: Color(0xff22d2d))
            ),
          ),
          Container(height: 32.h,),
          InkWell(
            onTap: () {
              if(null == _editingControllerPassword.text || _editingControllerPassword.text.isEmpty) {
                return;
              }
              FocusScope.of(context).unfocus();
              if(widget._from == SendFeeRoute) {
                eventBus.fire(SendPasswordInput(_editingControllerPassword.text));
              } else if(widget._from == CreateAccountRoute) {
                eventBus.fire(NewAccountPasswordInput(_editingControllerPassword.text));
              }
              Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 50.w, right: 50.w),
              decoration: getMinaButtonDecoration(topColor: Color(0xff9fe4c9)),
              child: Text('CONFIRM',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
            ),
          )
        ],
    )));
  }
}

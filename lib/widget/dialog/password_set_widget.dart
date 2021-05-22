import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class PasswordSetWidget extends StatefulWidget {
  PasswordSetWidget({Key? key}) : super(key: key);

  @override
  _PasswordSetWidgetState createState() => _PasswordSetWidgetState();
}

class _PasswordSetWidgetState extends State<PasswordSetWidget> {
  FocusNode _focusNodeNewPassword = FocusNode();
  TextEditingController _controllerNewPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNodeNewPassword?.dispose();
    _controllerNewPassword?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
 //   ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: Size(375, 812),
      orientation: Orientation.portrait
    );
    print('PasswordInputWidget: build(context: $context)');
    return KeyboardActions(
      tapOutsideToDismiss: false,
      autoScroll: false,
      disableScroll: true,
      config: KeyboardActionsConfig(
        keyboardSeparatorColor: Colors.grey,
        nextFocus: false,
        actions: [
          KeyboardActionsItem(focusNode: _focusNodeNewPassword)
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('images/password_lock_logo.png', width: 40.w, height: 40.w,),
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
                      focusNode: _focusNodeNewPassword,
                      controller: _controllerNewPassword,
                      onChanged: (text) {

                      },
                      maxLines: 1,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Please input seed password',
                        hintStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal, color: Color(0xffbdbdbd)))
                    )
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
            Container(
              padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
              child: Row(
                children: [
                  Container(width: 8,),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      enableInteractiveSelection: true,
                      focusNode: _focusNodeNewPassword,
                      controller: _controllerNewPassword,
                      onChanged: (text) {

                      },
                      maxLines: 1,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Please input seed password',
                        hintStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal, color: Color(0xffbdbdbd)))
                    )
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
                if(null == _controllerNewPassword.text || _controllerNewPassword.text.isEmpty) {
                  return;
                }
                FocusScope.of(context).unfocus();
                eventBus.fire(SendPasswordInput(_controllerNewPassword.text));
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 50.w, right: 50.w),
                decoration: getMinaButtonDecoration(topColor: Color(0xff9fe4c9)),
                child: Text('CONFIRM',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
                ),
              )
            ],
          )
      )
    );
  }
}

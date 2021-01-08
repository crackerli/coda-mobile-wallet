import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/types/send_data.dart';
import 'package:coda_wallet/util/navigations.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

_gotoSendAmount(BuildContext context, SendData sendData) {
  Navigator.of(context).pushReplacementNamed(SendAmountRoute, arguments: sendData);
}

class SendToScreen extends StatefulWidget {
  SendToScreen({Key key}) : super(key: key);

  @override
  _SendToScreenState createState() => _SendToScreenState();
}

class _SendToScreenState extends State<SendToScreen> {
  TextEditingController _toController   = TextEditingController();
  TextEditingController _memoController = TextEditingController();
  dynamic _qrResult;
  final _focusNodeTo       = FocusNode();
  final _focusNodeMemo     = FocusNode();
  bool _validInput = false;
  SendData _sendData;

  _fillQrAddress() async {
    _qrResult = await toQrScanScreen(context);
    _toController.text = '$_qrResult';
    _sendData.to = _toController.text;
    if(null != _toController.text && _toController.text.isNotEmpty) {
      _validInput = true;
    } else {
      _validInput = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _memoController?.dispose();
    _toController?.dispose();
    _focusNodeMemo?.dispose();
    _focusNodeTo?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    _sendData = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryBackgroundColor,
      appBar: buildNoTitleAppBar(context),
      body: KeyboardActions(
        tapOutsideToDismiss: true,
        autoScroll: true,
        config: KeyboardActionsConfig(
          keyboardSeparatorColor: Colors.grey,
          nextFocus: false,
          actions: [ KeyboardActionsItem(focusNode: _focusNodeTo), KeyboardActionsItem(focusNode: _focusNodeMemo)]
        ),
        child: SingleChildScrollView(
          child: _buildSendToBody(context)
        )
      )
    );
  }

  _buildSendToBody(BuildContext context) {
    return IntrinsicHeight(child:
      Column(children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 37.h),
                Text('Where are you sending MINA to?', textAlign: TextAlign.left, style: TextStyle(fontSize: 30.sp, color: Colors.black)),
                Container(height: 48.h),
                Text('SEND TO', textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
                Container(height: 8.h),
                _buildToAddressField(context),
                Container(height: 31.h),
                _buildMemoField(),
              ],
            )
          ),
          flex: 5,
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              RaisedButton(
                padding: EdgeInsets.only(top: 11.h, bottom: 11.h, left: 100.w, right: 100.w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.w))),
                onPressed: _validInput ? () => _gotoSendAmount(context, _sendData) : null,
                color: Colors.blueAccent,
                child: Text('Continue', style: TextStyle(fontSize: 17.sp, color: Colors.white, fontWeight: FontWeight.w600))
              ),
            Container(height: 18.h),
            InkWell(
              child: Text('Cancel', textAlign: TextAlign.center, style: TextStyle(fontSize: 17.sp, color: Color(0xff212121))),
              onTap: () => Navigator.of(context).pop(),
            ),
            Container(height: 16.h),
          ],
        ))
      ]
    ));
  }

  _buildToAddressField(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 18.63.w, right: 18.63.w, top: 13.h, bottom: 13.h),
      decoration: BoxDecoration(
        color: Color.fromARGB(20, 116, 116, 128),
        borderRadius: BorderRadius.all(Radius.circular(10.w))
      ),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: TextField(
            enableInteractiveSelection: true,
            focusNode: _focusNodeTo,
            controller: _toController,
            onChanged: (text) {
              if(null != text && text.isNotEmpty) {
                _validInput = true;
              } else {
                _validInput = false;
              }
              _sendData.to = text;
              setState(() {

              });
            },
            maxLines: null,
            keyboardType: TextInputType.multiline,
            autofocus: false,
            decoration: InputDecoration.collapsed(
              hintText: 'Tap to Paste Address',
              hintStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 0, 0, 0)))
          )),
          Container(width: 12.w),
          InkWell(
            child: Image.asset('images/qr_scan1.png', width: 22.w, height: 22.w),
            onTap: _fillQrAddress,
          )
        ],
      ),
    );
  }

  _buildMemoField() {
    return Container(
      padding: EdgeInsets.only(left: 18.63.w, right: 18.63.w, top: 13.h, bottom: 13.h),
      decoration: BoxDecoration(
          color: Color.fromARGB(20, 116, 116, 128),
          borderRadius: BorderRadius.all(Radius.circular(10.w))
      ),
      child: TextField(
        enableInteractiveSelection: true,
        focusNode: _focusNodeMemo,
        controller: _memoController,
        onChanged: (text) {
          _sendData.memo = text;
        },
        maxLines: null,
        keyboardType: TextInputType.multiline,
        autofocus: false,
        decoration: InputDecoration.collapsed(
          hintText: 'PERSONAL NOTE(OPTIONAL)',
          hintStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 181, 181, 181)))
        )
    );
  }
}

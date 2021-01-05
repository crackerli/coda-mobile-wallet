import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/send/screens/send_fee_screen.dart';
import 'package:coda_wallet/test/test_data.dart';
import 'package:coda_wallet/types/send_data.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

_gotoSendFee(BuildContext context, SendData sendData) {
  Navigator.of(context).pushReplacementNamed(SendFeeRoute, arguments: sendData);
}

class SendAmountScreen extends StatefulWidget {
  SendAmountScreen({Key key}) : super(key: key);

  @override
  _SendAmountScreenState createState() => _SendAmountScreenState();
}

class _SendAmountScreenState extends State<SendAmountScreen> {
  List<String> _keyString = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '< Clear'];
  List<Widget> _keys;
  List<String> _inputAmount;
  StringBuffer _amountBuffer;
  String _fiatPrice = '\$0.00';
  SendData _sendData;
  bool _validInput = false;

  String _formatFiatPrice() {
    return '\$$_amountBuffer';
  }

  @override
  void initState() {
    super.initState();
    _keys = List<Widget>();
    _inputAmount = List<String>();
    _inputAmount.add('0');
    _amountBuffer = StringBuffer();
    _amountBuffer.writeAll(_inputAmount);
  }

  @override
  void dispose() {
    _amountBuffer.clear();
    _inputAmount.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    _sendData = ModalRoute.of(context).settings.arguments;
    _keys = List.generate(_keyString.length, (index) => _buildKey(index));
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: buildAccountsAppBar(),
      body: _buildSendToBody(context)
    );
  }

  _buildSendToBody(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 50.w, right: 50.w),
          child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('BALANCE', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
                  RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: '${formatTokenNumber(testAccounts[0].balance)} ',
                        style: TextStyle(fontSize: 17.sp, color: Colors.black)),
                      TextSpan(
                        text: 'MINA',
                        style: TextStyle(
                          color: Color(0xff979797),
                          fontWeight: FontWeight.normal,
                          fontSize: 13.sp
                        )
                      ),
                    ]),
                  ),
                  Container(height: 24.h),
                  Container(
                    height: 54.h,
                    child: Center(
                      child: Text(_amountBuffer.toString(), textAlign: TextAlign.left, maxLines: 2, overflow: TextOverflow.visible,
                      style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500, color: Colors.black)))
                  ),
                  Container(height: 15.h,),
                  Text(_fiatPrice, textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500, color: Color(0xff979797))),
                  Container(height: 8.h),
                  _buildDecimalKeyboard(),
                ],
              )
          ),
          Positioned(
            bottom: 35.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  padding: EdgeInsets.only(top: 11.h, bottom: 11.h, left: 100.w, right: 100.w),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.w))),
                  onPressed: _validInput ? () => _gotoSendFee(context, _sendData) : null,
                  color: Colors.blueAccent,
                  child: Text('Continue', style: TextStyle(fontSize: 17.sp, color: Colors.white, fontWeight: FontWeight.w600))
              ),
              Container(height: 30.h),
              InkWell(
                child: Text('Cancel', textAlign: TextAlign.center, style: TextStyle(fontSize: 17.sp, color: Color(0xff212121))),
                onTap: () => Navigator.of(context).pop(),
              )
            ],
          )),
          Positioned(
            top: 0,
            right: 47.w,
            child: Text('SEND ALL', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp)))
        ]
    );
  }

  _fillInput() {
    _amountBuffer.clear();
    _amountBuffer.writeAll(_inputAmount);
    _fiatPrice = _formatFiatPrice();
    try {
      double sendAmount = double.parse(_amountBuffer.toString());
      _sendData.amount = _amountBuffer.toString();
      if(sendAmount == 0.0) {
        _validInput = false;
      } else {
        _validInput = true;
      }
      setState(() {

      });
    } catch(e) {
      _validInput = false;
      setState(() {

      });
    }
  }

  _tapOnKeyCallback(int index) {
    if(index == _keyString.length - 1) {
      if(_inputAmount.length == 1) {
        if(_inputAmount[0] == '0') {
          return;
        } else {
          _inputAmount[0] = '0';
          _fillInput();
          return;
        }
      }
      _inputAmount.removeLast();
      _fillInput();
    } else {
      if(_keyString[index] == '.') {
        _inputAmount.add(_keyString[index]);
        _fillInput();
        return;
      }

      if(_inputAmount.length == 1 && _inputAmount[0] == '0') {
        _inputAmount[0] = _keyString[index];
      } else {
        _inputAmount.add(_keyString[index]);
      }
      _fillInput();
    }
  }

  _buildKey(int index) {
    return InkWell(
      onTap: () => _tapOnKeyCallback(index),
      child: index == _keyString.length - 1
        ? _buildDeleteKey(index)
        : _buildNumericKey(index),
    );
  }

  _buildNumericKey(int index) {
    return
      Center(
        child: Text(_keyString[index], textAlign: TextAlign.center, style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600)),
    );
  }
  
  _buildDeleteKey(int index) {
    return
      Center(
        child: Text(_keyString[index], textAlign: TextAlign.center, style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.normal)),
    );
  }

  _buildDecimalKeyboard() {
    return Flexible(child: GridView.count(
      shrinkWrap: true,
      childAspectRatio: 1.1,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      padding: EdgeInsets.symmetric(vertical: 0),
      children: _keys,
    ));
  }
}

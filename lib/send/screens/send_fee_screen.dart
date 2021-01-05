import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/send/blocs/send_token_bloc.dart';
import 'package:coda_wallet/send/blocs/send_token_events.dart';
import 'package:coda_wallet/send/blocs/send_token_states.dart';
import 'package:coda_wallet/send/mutation/send_token_mutation.dart';
import 'package:coda_wallet/test/test_data.dart';
import 'package:coda_wallet/types/send_data.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class SendFeeScreen extends StatefulWidget {
  SendData _sendData;

  SendFeeScreen({Key key, SendData sendData}) : super(key: key) {
    _sendData = sendData;
  }

  @override
  _SendFeeScreenState createState() => _SendFeeScreenState();
}

class _SendFeeScreenState extends State<SendFeeScreen> {
//  SendData _sendData;
  SendTokenBloc _sendTokenBloc;

  _sendPayment() {
    _sendTokenBloc.sender = testAccounts[widget._sendData.from].address;
    _sendTokenBloc.sendAmount = widget._sendData.amount;
    _sendTokenBloc.memo = widget._sendData.memo;
    _sendTokenBloc.fee = widget._sendData.fee;
    _sendTokenBloc.receiver = widget._sendData.to;
    Map<String, dynamic> variables = Map<String, dynamic>();
    variables['from'] = _sendTokenBloc.sender;
    variables['to'] = _sendTokenBloc.receiver;
    variables['amount'] = getNanoMina(_sendTokenBloc.sendAmount);
    variables['memo'] = _sendTokenBloc.memo;
    variables['fee'] = getNanoMina(_sendTokenBloc.fee);
    variables['nonce'] = 3;
    variables['validUntil'] = 65535;
    // variables['from'] = 'B62qiy32p8kAKnny8ZFwoMhYpBppM1DWVCqAPBYNcXnsAHhnfAAuXgg';
    // variables['to'] = 'B62qrPN5Y5yq8kGE3FbVKbGTdTAJNdtNtB5sNVpxyRwWGcDEhpMzc8g';
    // variables['amount'] = 420000000;
    // variables['memo'] = 'this is a memo';
    // variables['fee'] = 300000000;
    // variables['nonce'] = 200;
    // variables['token'] = 1;
    // variables['validUntil'] = 10000;
    // variables['field'] = '6294031020844169724778227166138415676049686510656401727312236286674679501948';
    // variables['scalar'] = '4626454670027815473460098193984318559610067435921261084455739892582590642453';

    _sendTokenBloc.add(
      SendPayment(SEND_PAYMENT_MUTATION, variables: variables));
  }

  @override
  void initState() {
    super.initState();
    _sendTokenBloc = BlocProvider.of<SendTokenBloc>(context);
  }

  @override
  void dispose() {
    _sendTokenBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    //_sendData = ModalRoute.of(context).settings.arguments;
    // Default fee to be 0.1
    widget._sendData.fee = '0.1';
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: buildNoTitleAppBar(),
      body: BlocBuilder<SendTokenBloc, SendTokenStates>(
      builder: (BuildContext context, SendTokenStates state) {
       return Stack(
        alignment: Alignment.center,
        children: [
          _buildSendFeeBody(),
          Positioned(
            bottom: 35.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  padding: EdgeInsets.only(top: 11.h, bottom: 11.h, left: 100.w, right: 100.w),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.w))),
                  onPressed: _sendPayment,
                  color: Colors.blueAccent,
                  child: Text('Send', style: TextStyle(fontSize: 17.sp, color: Colors.white, fontWeight: FontWeight.w600))
                ),
                Container(height: 30.h),
                InkWell(
                  child: Text('Cancel', textAlign: TextAlign.center, style: TextStyle(fontSize: 17.sp, color: Color(0xff212121))),
                  onTap: () => Navigator.of(context).pop(),
                )
              ],
            )
          )
        ],
      );})
    );
  }

  _buildSendFeeBody() {
    return Container(
      padding: EdgeInsets.only(left: 50.w, right: 50.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 14.h),
          Center(child:
          Container(
            width: 75.w,
            height: 75.w,
            color: Colors.grey,
          )),
          Container(height: 64.h),
          Text('SEND FROM', textAlign: TextAlign.left,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
          Text(testAccounts[widget._sendData.from].address,
              textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xffa0a0a0))),
          Container(height: 27.h),
          Text('SEND TO',  textAlign: TextAlign.left,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
          Text(widget._sendData.to,
            textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xffa0a0a0))),
          Container(height: 27.h),
          Text('AMOUNT',
            textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: '${widget._sendData.amount} ',
                style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w500, color: Colors.black)),
              TextSpan(
                text: 'MINA (\$35,63)',
                style: TextStyle(color: Color(0xff979797), fontWeight: FontWeight.w500, fontSize: 16.sp)
              )]
            )
          ),
          Container(height: 25.h,),
          Text('MEMO',
            textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
          Text('${widget._sendData.memo}', textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),),
          Container(height: 36.h,),
          Text('NETWORK FEE',
            textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67)),),
          Text('${widget._sendData.fee}', textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),)
        ]
      )
    );
  }
}

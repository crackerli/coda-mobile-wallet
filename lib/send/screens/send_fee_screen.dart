import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/test/test_data.dart';
import 'package:coda_wallet/types/send_data.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendFeeScreen extends StatefulWidget {
  SendFeeScreen({Key key}) : super(key: key);

  @override
  _SendFeeScreenState createState() => _SendFeeScreenState();
}

class _SendFeeScreenState extends State<SendFeeScreen> {
  SendData _sendData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    _sendData = ModalRoute.of(context).settings.arguments;
    // Default fee to be 0.1
    _sendData.fee = '0.1';
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: buildAccountsAppBar(),
      body: Stack(
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
                  onPressed: null,
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
      )
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
          Text(testAccounts[_sendData.from].address,
              textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xffa0a0a0))),
          Container(height: 27.h),
          Text('SEND TO',  textAlign: TextAlign.left,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
          Text(_sendData.to,
            textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xffa0a0a0))),
          Container(height: 27.h),
          Text('AMOUNT',
            textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: '${_sendData.amount} ',
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
          Text('${_sendData.memo}', textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),),
          Container(height: 36.h,),
          Text('NETWORK FEE',
            textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67)),),
          Text('${_sendData.fee}', textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),)
        ]
      )
    );
  }
}

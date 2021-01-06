import 'package:coda_wallet/global/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TxnDetailScreen extends StatefulWidget {

  TxnDetailScreen({Key key}) : super(key: key);

  @override
  _TxnDetailScreenState createState() => _TxnDetailScreenState();
}

class _TxnDetailScreenState extends State<TxnDetailScreen> {

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
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: null,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildSendFeeBody(),
            _buildActionsButton(context),
            _buildCloseButton()
          ]
        )
      )
    );
  }

  _buildCloseButton() {
    return Positioned(
      right: 36.h,
      top: 30.h,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 16.w,
          height: 16.w,
          color: Colors.grey,
        )
      )
    );
  }

  _buildActionsButton(BuildContext context) {
    return Positioned(
      bottom: 44.h,
      child: RaisedButton(
        padding: EdgeInsets.only(top: 11.h, bottom: 11.h, left: 50.w, right: 50.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.w))),
        onPressed: null,
        color: Colors.blueAccent,
        child: Text('View in Explorer', style: TextStyle(fontSize: 17.sp, color: Colors.white))
      )
    );
  }

  _buildSendFeeBody() {
    return Container(
      padding: EdgeInsets.only(left: 50.w, right: 50.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(height: 36.h),
          Center(child:
            Container(
              width: 67.w,
              height: 67.w,
              color: Colors.grey,
            )
          ),

          Container(height: 16.h),
          Center(child:
            Text('Transaction Sent', textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600))
          ),
          Container(height: 22.h,),
          Text('SEND FROM', textAlign: TextAlign.left,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
          Text('B62qksdP349sXvavFnQj7JYeKRfLbLaTsgjGecj8MBfzXcLkY18atHe',
            textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.black)),
          Container(height: 17.h),
          Text('SEND TO', textAlign: TextAlign.left,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
          Text('B62qksdP349sXvavFnQj7JYeKRfLbLaTsgjGecj8MBfzXcLkY18atHe',
            textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.black)),
          Container(height: 16.h),
          Text('AMOUNT', textAlign: TextAlign.left,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
          Text('12345.00 MINA',
            textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.black)),
          Text('(\$46.62))',
            textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.black)),
          Container(height: 8.h,),
          Text('NETWORK FEE',
            textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67)),),
          Text('0.1 MINA (\$0.07)', textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),),
          Container(height: 20.h,),
          Text('TOTAL',
            textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67)),),
          Text('0.1 MINA (\$0.07)', textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),),
          Container(height: 18.h,),
          Text('TIMESTAMP',
            textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67)),),
          Text('31 Dec 2020 23:59:00', textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),),
          Container(height: 11.h,),
          Text('MEMO', textAlign: TextAlign.left,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
          Text('Sent from Chris', textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),),
        ]
      )
    );
  }
}

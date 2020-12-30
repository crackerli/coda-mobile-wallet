import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendAmountScreen extends StatefulWidget {
  SendAmountScreen({Key key}) : super(key: key);

  @override
  _SendAmountScreenState createState() => _SendAmountScreenState();
}

class _SendAmountScreenState extends State<SendAmountScreen> {

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
                  Text('BALANCE', textAlign: TextAlign.center, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 60, 60, 67))),
                  Container(height: 48.h),
                  Text('0', textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w500, color: Colors.black)),
                  Text('\$0.00', textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w500, color: Color(0xff979797))),
                  Container(height: 8.h),
                  Container(height: 31.h),
                  _buildKeyboard(),
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
                      onPressed: null,
                      color: Colors.blueAccent,
                      child: Text('Continue', style: TextStyle(fontSize: 17.sp, color: Colors.white, fontWeight: FontWeight.w600))
                  ),
                  Container(height: 30.h),
                  InkWell(
                    child: Text('Cancel', textAlign: TextAlign.center, style: TextStyle(fontSize: 17.sp, color: Color(0xff212121))),
                    onTap: () => Navigator.of(context).pop(),
                  )
                ],
              ))
        ]
    );
  }

  List<Widget> _testKB = [
    InkWell(
      onTap: null,
      child: Text('1'),
    ),
    InkWell(
      onTap: null,
      child: Text('2'),
    ),
    InkWell(
      onTap: null,
      child: Text('3'),
    ),
    InkWell(
      onTap: null,
      child: Text('4'),
    ),
    InkWell(
      onTap: null,
      child: Text('5'),
    ),
    InkWell(
      onTap: null,
      child: Text('6'),
    ),
    InkWell(
      onTap: null,
      child: Text('7'),
    ),
    InkWell(
      onTap: null,
      child: Text('8'),
    ),
    InkWell(
      onTap: null,
      child: Text('9'),
    )
  ];

  _buildKeyboard() {
    return Flexible(
      child: GridView.count(
        crossAxisCount: 3,
        padding: EdgeInsets.symmetric(vertical: 0),
        children: _testKB,
      )
    );
  }
}

import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/send/screens/send_amount_screen.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendToScreen extends StatefulWidget {
  SendToScreen({Key key}) : super(key: key);

  @override
  _SendToScreenState createState() => _SendToScreenState();
}

class _SendToScreenState extends State<SendToScreen> {

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
        Positioned(
          bottom: 35.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RaisedButton(
                padding: EdgeInsets.only(top: 11.h, bottom: 11.h, left: 100.w, right: 100.w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.w))),
                onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SendAmountScreen())),
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
            // focusNode: _focusNodeReceiver,
            // controller: _addressController,
            onChanged: (text) {
              // _sendTokenBloc.receiver = text;
              // _sendTokenBloc.add(ValidateInput());
            },
            maxLines: null,
            keyboardType: TextInputType.multiline,
            autofocus: false,
            decoration: InputDecoration.collapsed(
              hintText: 'Tap to Paste Address',
              hintStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color.fromARGB(153, 0, 0, 0)))
          )),
          Container(width: 12.w),
          Image.asset('images/qr_scan1.png', width: 22.w, height: 22.w,),
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
        // focusNode: _focusNodeReceiver,
        // controller: _addressController,
        onChanged: (text) {
          // _sendTokenBloc.receiver = text;
          // _sendTokenBloc.add(ValidateInput());
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

import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/types/send_error_type.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class SendErrorWidget extends StatefulWidget {
  SendErrorType _errorType;
  String _error;
  SendErrorWidget(this._errorType, this._error, {Key? key}) : super(key: key);

  @override
  _SendErrorWidgetState createState() => _SendErrorWidgetState();
}

class _SendErrorWidgetState extends State<SendErrorWidget> {

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
  //  ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: Size(375, 812),
      orientation: Orientation.portrait
    );
    print('SendErrorWidget: build(context: $context)');
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Image.asset('images/close.png', width: 18.w, height: 18.w,),
              )
            ],
          ),
          Image.asset('images/send_error_alert.png', width: 60.w, height: 51.h,),
          Container(height: 24.h,),
          Text('Transaction Error', textAlign: TextAlign.center, style: TextStyle(fontSize: 26.sp, color: Color(0xff2d2d2d)),),
          Container(height: 15.h,),
          Text(widget._error, textAlign: TextAlign.center, maxLines: 3,
            style: TextStyle(fontSize: 16.sp, color: Color(0xff2d2d2d)),),
          Container(height: 33.h,),
          InkWell(
            onTap: () {
              if(widget._errorType == SendErrorType.GET_POOL_FEE) {
                eventBus.fire(GetPooledFeeAgain());
              }

              if(widget._errorType == SendErrorType.GET_NONCE) {
                eventBus.fire(GetNonceAgain());
              }

              if(widget._errorType == SendErrorType.SEND_PAYMENT) {
                eventBus.fire(SendPaymentAgain());
              }
              Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 70.w, right: 70.w),
              decoration: getMinaButtonDecoration(topColor: Color(0xffe0e0e0)),
              child: Text('TRY AGAIN',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
            ),
          ),
          Container(height: 16.h,)
        ],
      )
    );
  }
}

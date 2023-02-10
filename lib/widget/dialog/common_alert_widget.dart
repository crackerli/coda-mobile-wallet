import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonAlertWidget extends StatefulWidget {
  final String content;
  final String actionLabel;
  final Function? actionCallback;

  CommonAlertWidget(
    this.content,
    this.actionLabel,
    this.actionCallback,
    {Key? key}
  ) : super(key: key);

  @override
  _CommonAlertWidgetState createState() => _CommonAlertWidgetState();
}

class _CommonAlertWidgetState extends State<CommonAlertWidget> {

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
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true, splitScreenMode: false, scaleByHeight: false);

    print('CommonAlertWidget: build(context: $context)');
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 15.h,),
          Image.asset('images/send_error_alert.png', width: 60.w, height: 51.h,),
          Container(height: 12.h,),
          Text(widget.content,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 16.sp, color: Color(0xff2d2d2d), fontWeight: FontWeight.w500),),
          Container(height: 16.h,),
          InkWell(
            onTap: () {
              if(null != widget.actionCallback) widget.actionCallback!();
              Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 70.w, right: 70.w),
              decoration: getMinaButtonDecoration(topColor: Color(0xffe0e0e0)),
              child: Text(widget.actionLabel,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
            ),
          ),
          Container(height: 16.h,)
        ],
      )
    );
  }
}

import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UrlWarningWidget extends StatefulWidget {
  final String url;
  UrlWarningWidget(this.url, {Key? key}) : super(key: key);

  @override
  _UrlWarningWidgetState createState() => _UrlWarningWidgetState();
}

class _UrlWarningWidgetState extends State<UrlWarningWidget> {

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
    print('UrlWarningWidget: build(context: $context)');
    return
      IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.w)),
            color: Colors.white
          ),
          padding: EdgeInsets.only(top: 12.h, bottom: 12.h, left: 12.w, right: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset('images/close.png', width: 18.w, height: 18.w,),
                  )
                ],
              ),
              Image.asset('images/send_error_alert.png', width: 60.w, height: 51.h,),
              Container(height: 12.h,),
              Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.w),
                child: Text('You will open a url that may be untrusted, please pay attention to the associated risks',
                  maxLines: 4, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 16.sp),),
              ),
              Container(height: 12.h,),
              Text(widget.url, maxLines: 4, textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueAccent, fontSize: 16.sp, decoration: TextDecoration.underline)),
              Container(height: 22.h,),
              Builder(builder: (BuildContext context) =>
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    openUrl(widget.url);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 50.w, right: 50.w),
                    decoration: getMinaButtonDecoration(topColor: Color(0xfff5f5f5)),
                    child: Text('OPEN ANYWAY',
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
                  ),
                )
              )
            ],
          )
        )
    );
  }
}

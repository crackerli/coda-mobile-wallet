import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/widget/tab/customized_tab_indicator.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

showTxnFilterBottomSheet(BuildContext context) {
  List<String> topList = ['All', 'Sent', 'Received', 'Staked'];
  showModalBottomSheet(
    enableDrag: false,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(7.0))),
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(31, 118, 118, 128),
          borderRadius: BorderRadius.all(
            Radius.circular(7.0),
          )
        ),
        margin: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.all(1.5),
            child: DefaultTabController(
              length: 4,
              child: TabBar(
                onTap: (i) => print('Tab $i clicked'),
                indicatorColor: Colors.blue,
                indicator: CustomizedUnderlineTabIndicator(),
                labelPadding: EdgeInsets.zero,
                unselectedLabelColor: Colors.black,
                tabs: topList.map((String name) => Container(child: Tab(text: name))).toList(),
              ),
            )
          )
        );
      }
  );
}

showTxnFilterSheet(BuildContext context, List<String> actions, int currentFilter) {
  showModalBottomSheet(
    enableDrag: false,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(7.0))),
    context: context,
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(7.w),
          )
        ),
        margin: EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.only(top: 8.h, left: 52.w, right: 52.w, bottom: 8.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset('images/filter_logo.png', width: 40.w, height: 40.w,),
              Container(height: 16.h,),
              Text('Filter Transactions', textAlign: TextAlign.center, style: TextStyle(color: Color(0xff2d2d2d), fontSize: 24.sp),),
              Container(height: 16.h,),
              InkWell(
                onTap: () {
                  eventBus.fire(FilterTxnsAll());
                  Navigator.pop(context);
                },
                child: Container(
                  width: 266.w,
                  padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 94.w, right: 94.w),
                  decoration: getMinaButtonDecoration(
                    topColor: 0 == currentFilter ? Color(0xff9fe4c9) : Color(0xffeeeeee)
                  ),
                  child: Text(actions[0],
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
                ),
              ),
              Container(height: 11.h,),
              InkWell(
                onTap: () {
                  eventBus.fire(FilterTxnsSent());
                  Navigator.pop(context);
                },
                child: Container(
                  width: 266.w,
                  padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 94.w, right: 94.w),
                  decoration: getMinaButtonDecoration(
                    topColor: 1 == currentFilter ? Color(0xff9fe4c9) : Color(0xffeeeeee)
                  ),
                  child: Text(actions[1],
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
                ),
              ),
              Container(height: 11.h,),
              InkWell(
                onTap: () {
                  eventBus.fire(FilterTxnsReceived());
                  Navigator.pop(context);
                },
                child: Container(
                  width: 266.w,
                  padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 94.w, right: 94.w),
                  decoration: getMinaButtonDecoration(
                    topColor: 2 == currentFilter ? Color(0xff9fe4c9) : Color(0xffeeeeee)
                  ),
                  child: Text(actions[2],
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
                ),
              ),
              Container(height: 11.h,),
              InkWell(
                onTap: () {
                  eventBus.fire(FilterTxnsStaked());
                  Navigator.pop(context);
                },
                child: Container(
                  width: 266.w,
                  padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 94.w, right: 94.w),
                  decoration: getMinaButtonDecoration(
                    topColor: 3 == currentFilter ? Color(0xff9fe4c9) : Color(0xffeeeeee)
                  ),
                  child: Text(actions[3],
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
                ),
              ),
              Container(height: 22.h,),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 94.w, right: 94.w),
                  child: Text(actions[4],
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        )
      );
    }
  );
}
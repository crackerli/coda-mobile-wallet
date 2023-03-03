import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/txns/constant/txns_filter_constant.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

_buildFilterButton(
  BuildContext context,
  TxnFilter matchFilter,
  TxnFilter currentFilter,
  List<String> actions,
  dynamic event) {
  return SizedBox(
    width: 266.w,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
        foregroundColor: matchFilter == currentFilter ? Colors.white : Color(0xff098de6),
        backgroundColor: matchFilter == currentFilter ? Color(0xff098de6) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
        side: BorderSide(width: 1.w, color: Color(0xff098de6))
    ),
    onPressed: () {
      eventBus.fire(event);
      Navigator.pop(context);
    },
    child: Text(actions[matchFilter.index], textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500,
      color: matchFilter == currentFilter ? Colors.white : Color(0xff098de6)))
  ));
}

showTxnFilterSheet(BuildContext context, List<String> actions, TxnFilter currentFilter) {
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
        margin: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
        child: Container(
          padding: EdgeInsets.only(top: 8.h, left: 30.w, right: 30.w, bottom: 8.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset('images/filter_logo_blue.png', width: 44.w, height: 44.w),
              Container(height: 16.h,),
              Text('Transaction Filters', textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff2d2d2d), fontSize: 20.sp, fontWeight: FontWeight.w500)),
              Container(height: 16.h,),
              _buildFilterButton(context, TxnFilter.ALL, currentFilter, actions, FilterTxnsAll()),
              Container(height: 1.h,),
              _buildFilterButton(context, TxnFilter.SENT, currentFilter, actions, FilterTxnsSent()),
              Container(height: 1.h,),
              _buildFilterButton(context, TxnFilter.RECEIVED, currentFilter, actions, FilterTxnsReceived()),
              Container(height: 1.h,),
              _buildFilterButton(context, TxnFilter.STAKED, currentFilter, actions, FilterTxnsStaked()),
              Container(height: 12.h,),
              SizedBox(
                width: 266.w,
                child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
                  foregroundColor: Color(0xfffe5962),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
                  side: BorderSide(width: 1.w, color: Color(0xfffe5962))
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('CANCEL', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xfffe5962)))
              ))
            ],
          ),
        )
      );
    }
  );
}
import 'package:coda_wallet/test/test_data.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

typedef AccountClickCb = void Function(int index);

buildAccountList(AccountClickCb accountClickCb) {
  return ListView.separated(
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: testAccounts.length,
    itemBuilder: (context, index) {
      return _buildAccountItem(accountClickCb, testAccounts, index);
    },
    separatorBuilder: (context, index) { return Container(height: 20.h); }
  );
}

_buildAccountItem(Function accountClickCb, List<MinaHDAccount> accounts, int index) {
  return InkWell(
    onTap: () => accountClickCb(index),
    child:
      Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.w),
        color: Colors.white,
        border: Border.all(color: Color(0xff2d2d2d), width: 1.w)
      ),
      margin: EdgeInsets.only(left: 18.w, right: 18.w),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(textBaseline: TextBaseline.alphabetic, ),
                  children: [
                    WidgetSpan(
                      alignment: ui.PlaceholderAlignment.middle,
                      child: Image.asset('images/account_header.png', width: 22.w, height: 22.w,),
                    ),
                    TextSpan(text: accounts[index].accountName, style: TextStyle(fontSize: 16.sp, color: Color(0xff2d2d2d))),
                  ],
                ),
              ),
              Container(width: 20.w,),
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(children: [
                  WidgetSpan(
                    alignment: ui.PlaceholderAlignment.middle,
                    child: Image.asset('images/pool_header.png', width: 12.w, height: 12.w,),
                  ),
                  TextSpan(
                    text: ' ${accounts[index].pool}',
                    style: TextStyle(
                      color: Color(0xff616161),
                      fontWeight: FontWeight.normal,
                      fontSize: 12.sp
                    )
                  ),
                ]),
              ),
              ],
            ),
            Container(height: 4.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatHashEllipsis(accounts[index].address),
                  textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, color: Color(0xff9e9e9e))),
                Container(width: 20.w,),
                Expanded(
                  flex: 1,
                  child:
                RichText(
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: '${formatTokenNumber(accounts[index].balance)} ',
                      style: TextStyle(fontSize: 22.sp, color: Color(0xff616161))),
                    TextSpan(
                      text: 'MINA',
                      style: TextStyle(
                        color: Color(0xff2d2d2d),
                        fontWeight: FontWeight.normal,
                        fontSize: 12.sp
                      )
                    ),
                  ]),
                ),
                )],
            )
          ]
      ),
    )
  );
}
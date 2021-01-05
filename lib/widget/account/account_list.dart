import 'package:coda_wallet/test/test_data.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef AccountClickCb = void Function(int index);

buildAccountList(AccountClickCb accountClickCb) {
  return ListView.separated(
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: testAccounts.length,
    itemBuilder: (context, index) {
      return _buildAccountItem(accountClickCb, testAccounts, index);
    },
    separatorBuilder: (context, index) { return Container(height: 10.h); }
  );
}

_buildAccountItem(Function accountClickCb, List<MinaHDAccount> accounts, int index) {
  return InkWell(
    onTap: () => accountClickCb(index),
    child:
      Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 0.5)
      ),
      margin: EdgeInsets.only(left: 18.w, right: 18.w),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(accounts[index].accountName, textAlign: TextAlign.left, style: TextStyle(fontSize: 17.sp, color: Colors.black)),
              Container(width: 20.w,),
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: '${formatTokenNumber(accounts[index].balance)} ',
                    style: TextStyle(fontSize: 17.sp, color: Colors.black)),
                  TextSpan(
                    text: 'MINA',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 12.sp
                    )),
                  ]),
                ),
              ],
            ),
            Container(height: 4.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatHashEllipsis(accounts[index].address), textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, color: Color(0xffb1b1b1))),
                Container(width: 20.w,),
                RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: 'Staking with ',
                      style: TextStyle(fontSize: 13.sp.sp, color: Color(0xff929292))),
                    TextSpan(
                      text: accounts[index].pool,
                      style: TextStyle(
                        color: Color(0xff929292),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp
                    )),
                  ]),
                ),
              ],
            )
          ]
      ),
    )
  );
}
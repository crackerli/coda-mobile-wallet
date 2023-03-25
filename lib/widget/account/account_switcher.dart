import 'package:flutter/material.dart';
import '../../global/global.dart';
import '../../types/mina_hd_account_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../util/format_utils.dart';

typedef AccountSwitchCallback = void Function(AccountBean?)?;

buildAccountSwitcher(BuildContext context, int accountIndex, AccountSwitchCallback callback) {
  return Container(
    margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
    padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
    decoration: BoxDecoration(
      border: Border.all(color: Color(0xff979797), width: 0.5.w),
      borderRadius: BorderRadius.all(Radius.circular(8.w)),
      color: Color(0xfffdfdfd),
    ),
    child: DropdownButton<AccountBean>(
      isExpanded: true,
      dropdownColor: Color(0xfffdfdfd),
      value: globalHDAccounts.accounts![accountIndex],
      icon: Image.asset('images/arrow_down_filling.png', width: 14.w, height: 14.w),
      elevation: 6,
      style: const TextStyle(color: Color(0xff2d2d2d)),
      onChanged: callback,
      underline: Container(),
      items: globalHDAccounts.accounts!.map<DropdownMenuItem<AccountBean>>((AccountBean? value) {
        return DropdownMenuItem<AccountBean>(
          value: value,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('images/account_header1.png', width: 12.w, height: 12.w,),
              Container(width: 4.w,),
              Expanded(
                flex: 1,
                child: Text.rich(
                  textAlign: TextAlign.start,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: value?.accountName ?? 'null',
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),
                      ),
                      TextSpan(
                        text: '  (${formatHashEllipsis(value!.address!, short: false)})',
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w300, color: Color(0xff2d2d2d))
                      ),
                    ]
                  ))),
                ],
              ));
        }).toList(),
      )
  );
}
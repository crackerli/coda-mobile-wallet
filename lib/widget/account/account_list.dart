import 'dart:convert';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_entity.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:ffi_mina_signer/util/mina_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

typedef AccountClickCb = void Function(int index);

String _getStakingProvider(String stakingAddress, Map<String, dynamic> providerMap) {
  if(null == stakingAddress || stakingAddress.isEmpty) {
    return '';
  }

  if(null == providerMap || null == providerMap[stakingAddress]) {
    return formatHashEllipsis(stakingAddress);
  }

  Staking_providersBean provider = providerMap[stakingAddress];
  return provider.providerTitle;
}

buildAccountList(AccountClickCb accountClickCb) {
  String providerString = globalPreferences.getString(STAKETAB_PROVIDER_KEY);
  Map<String, dynamic> providerMap;
  if(null != providerString && providerString.isNotEmpty) {
    providerMap = json.decode(providerString);
  }

  return ListView.separated(
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: globalHDAccounts.accounts.length,
    itemBuilder: (context, index) {
      return _buildAccountItem(accountClickCb, globalHDAccounts.accounts, index, providerMap);
    },
    separatorBuilder: (context, index) { return Container(height: 20.h); }
  );
}

_buildAccountItem(Function accountClickCb, List<AccountBean> accounts, int index, Map<String, dynamic> providerMap) {
  return InkWell(
    onTap: () => accountClickCb(index),
    child:
      Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.w),
        color: Colors.white,
        border: Border.all(color: Color(0xff2d2d2d), width: 1.w)
      ),
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
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
                      child: Image.asset('images/account_header.png', width: 8.w, height: 8.w,),
                    ),
                    TextSpan(text: '  ${accounts[index].accountName}', style: TextStyle(fontSize: 16.sp, color: Color(0xff2d2d2d))),
                  ],
                ),
              ),
              Container(width: 20.w,),
              (accounts[index].stakingAddress.isNotEmpty && accounts[index].stakingAddress != accounts[index].address) ?
              RichText(
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 1,
                textAlign: TextAlign.right,
                text: TextSpan(children: [
                  WidgetSpan(
                    alignment: ui.PlaceholderAlignment.middle,
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Image.asset('images/pool_header.png', width: 12.w, height: 12.w)
                    )
                  ),
                  TextSpan(
                    text: ' ${_getStakingProvider(accounts[index].stakingAddress, providerMap)}',
                    style: TextStyle(
                      color: Color(0xff616161),
                      fontWeight: FontWeight.normal,
                      fontSize: 12.sp
                    )
                  ),
                ]),
              ) : Container()],
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
                  child: (accounts[index].isActive ?? false) ?
                    RichText(
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: '${MinaHelper.getMinaStrByNanoStr(accounts[index].balance)} ',
                          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Color(0xff616161))),
                        TextSpan(
                          text: 'MINA',
                          style: TextStyle(
                            color: Color(0xff2d2d2d),
                            fontWeight: FontWeight.normal,
                            fontSize: 12.sp
                          )
                        ),
                      ]
                    )
                  ) : Text('Inactive', textAlign: TextAlign.right, style: TextStyle(fontSize: 16.sp, color: Colors.redAccent))
                )
              ],
            )
          ]
      ),
    )
  );
}
import 'dart:convert';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_entity.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountStakeScreen extends StatefulWidget {
  AccountStakeScreen({Key? key}) : super(key: key);

  @override
  _AccountStakeScreenState createState() => _AccountStakeScreenState();
}

class _AccountStakeScreenState extends State<AccountStakeScreen> {
  int _accountIndex = -1;
  late Map<String, dynamic> _providerMap;
  Staking_providersBean? _provider;

  @override
  void initState() {
    super.initState();
    String? providerString = globalPreferences.getString(STAKETAB_PROVIDER_KEY);
    if(null != providerString && providerString.isNotEmpty) {
      _providerMap = json.decode(providerString);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('AccountStakeScreen build()');
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: Size(375, 812),
      orientation: Orientation.portrait
    );
    _accountIndex = ModalRoute.of(context)!.settings.arguments as int;
    String? stakingAddress = globalHDAccounts.accounts![_accountIndex]!.stakingAddress;
    _provider = Staking_providersBean.fromMap(_providerMap[stakingAddress])!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildNoTitleAppBar(context, leading: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child:
          Padding(
            padding: EdgeInsets.only(left: 18.w, right: 18.w),
            child: Column(
            children: [
              Container(height: 42.h),
              Container(
                width: double.infinity,
                child: Center(
                  child: Image.asset('images/account_staked.png', width: 80.w, height: 80.w,),
                )
              ),
              Container(height: 24.h,),
              RichText(
                textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: 'You Are Staking with ',
                      style: TextStyle(fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.normal)),
                  TextSpan(
                    text: '${_provider?.providerTitle ?? ''}',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp)),
                  ]
                )
              ),
              Container(height: 20.h,),
              Text('Know Your Provider', textAlign: TextAlign.center, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),),
              Container(height: 12.h,),
              _buildProvider(context),
              Container(height: 40.h,),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    StakeProviderRoute, arguments: _accountIndex);
                },
                child: Container(
                  padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 60.w, right: 60.w),
                  decoration: getMinaButtonDecoration(topColor: Color(0xffeeeeee)),
                  child: Text('CHANGE STAKING POOL',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
                )
              ),
              Container(height: 20.h,),
            ],
          )
        ))
      )
    );
  }

  _buildProvider(BuildContext context) {
    return Column(children: [
      Container(
        width: double.infinity,
        height: 1.h,
        color: Color(0xff757575)),
      Container(height: 2.h,),
      Container(
        width: double.infinity,
        height: 1.h,
        color: Color(0xff757575)),
      Container(height: 28.h,),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text('TITLE', textAlign: TextAlign.right, maxLines: 2,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d))),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Text('${_provider?.providerTitle ?? ''}',
              textAlign: TextAlign.left, maxLines: 3,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal, color: Color(0xff616161))),
          )
        ],
      ),
      Container(height: 16.h),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text('WEBSITE', textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d))),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Text('${_provider?.website ?? ''}',
              textAlign: TextAlign.left, maxLines: 3,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal, color: Color(0xff616161))),
          )
        ],
      ),
      Container(height: 16.h),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text('ADDRESS', textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d)),),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Text('${_provider?.providerAddress ?? ''}',
              textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, color: Color(0xff616161)),),
          )
        ],
      ),
      Container(height: 16.h),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text('STAKE SUM', textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d))),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Text('${_provider?.stakedSum?.floor().toString() ?? ''}', maxLines: 3,
              textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, color: Color(0xff616161))),
          )
        ],
      ),
      Container(height: 16.h,),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text('STAKE PERCENT', textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d)),),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Text('${_provider?.stakePercent?.toString() ?? ''}%', textAlign: TextAlign.left, maxLines: 2,
              style: TextStyle(fontSize: 13.sp,  color: Color(0xff616161))),
          )
        ],
      ),
      Container(height: 16.h,),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text('FEE', textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d)),),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Text('${_provider?.providerFee ?? ''}%', textAlign: TextAlign.left, maxLines: 2,
              style: TextStyle(fontSize: 13.sp,  color: Color(0xff616161))),
          )
        ],
      ),
      Container(height: 16.h,),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text('PAYOUT TERMS', textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d)),),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Text('${_provider?.payoutTerms ?? ''}', textAlign: TextAlign.left, maxLines: 2,
              style: TextStyle(fontSize: 13.sp,  color: Color(0xff616161))),
          )
        ],
      ),
      Container(height: 16.h,),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text('CONTACTS', textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d)),),
          ),
          Container(width: 8.w,),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (_provider?.discordUsername ?? '').isNotEmpty ?
                Builder(builder: (context) =>
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _provider?.discordUsername ?? ''));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Discord user name copied into clipboard!!')));
                    },
                    child: Image.asset('images/discord.png', height: 26.h, width: 26.w,)
                  )
                ) : Container(),
                (_provider?.telegram ?? '').isNotEmpty ?
                Builder(builder: (context) =>
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _provider?.telegram ?? ''));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Telegram handle copied into clipboard!!')));
                    },
                    child: Image.asset('images/telegram.png', height: 26.h, width: 26.w,)
                  )
                ) : Container(),
                (_provider?.twitter ?? '').isNotEmpty ?
                Builder(builder: (context) =>
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _provider?.twitter ?? ''));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Twitter account copied into clipboard!!')));
                    },
                    child: Image.asset('images/twitter.png', height: 26.h, width: 26.w,)
                  )
                ) : Container(),
                (_provider?.email ?? '').isNotEmpty ?
                Builder(builder: (context) =>
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _provider?.email ?? ''));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email copied into clipboard!!')));
                    },
                    child: Image.asset('images/mail.png', height: 26.h, width: 26.w,)
                  )
                ) : Container(),
              ],
            ),
          )
        ],
      ),
      Container(height: 28.h),
      Container(
        width: double.infinity,
        height: 1.h,
        color: Color(0xff757575)),
      Container(height: 2.h,),
      Container(
        width: double.infinity,
        height: 1.h,
        color: Color(0xff757575)),
    ],);
  }
}
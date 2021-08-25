import 'dart:convert';
import 'dart:typed_data';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:coda_wallet/types/send_data.dart';
import 'package:coda_wallet/util/stake_utils.dart';
import 'package:coda_wallet/wallet_home/blocs/account_bloc.dart';
import 'package:coda_wallet/wallet_home/blocs/account_events.dart';
import 'package:coda_wallet/wallet_home/blocs/account_states.dart';
import 'package:coda_wallet/widget/dialog/upgrade_cipher_dialog.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:coda_wallet/widget/ui/custom_gradient.dart';
import 'package:ffi_mina_signer/util/mina_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

_gotoSendFromScreen(BuildContext context) {
  SendData sendData = SendData();
  sendData.isDelegation = false;
  Navigator.of(context).pushNamed(SendFromRoute, arguments: sendData);
}

_gotoReceiveAccountsScreen(BuildContext context) {
  Navigator.of(context).pushNamed(ReceiveAccountsRoute);
}

class WalletHomeScreen extends StatefulWidget {
  WalletHomeScreen({Key? key}) : super(key: key);

  @override
  _WalletHomeScreenState createState() => _WalletHomeScreenState();
}

class _WalletHomeScreenState extends State<WalletHomeScreen> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, RouteAware {
  bool _stakeEnabled = true;
  late var _accountBloc;
  var _eventBusOn;
  bool _hasUpgradePopped = false;

  _updateAccounts({bool newRoute = false}) {
    bool newUser;
    // If either or accounts are null, we force user to re-generate them
    if(null == globalEncryptedSeed
       || globalEncryptedSeed!.isEmpty
       || globalHDAccounts.accounts == null
       || globalHDAccounts.accounts!.length == 0
    ) {
      newUser = true;
    } else {
      newUser = false;
    }

    if(newUser && newRoute) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushNamed(context, NoWalletRoute);
      });
    } else {
      // Read the prefix of encrypted seed to see if it using pointycastle,
      // If yes, recommend user to re-encrypt seed with new cipher algorithm.
      // This code is ugly, it expose the details of ffi_mina_signer, but however,
      // It is a temporary solution, it can be removed once all users
      if(null != globalEncryptedSeed && globalEncryptedSeed!.isNotEmpty) {
        Uint8List encryptedSeed = MinaHelper.hexToBytes(globalEncryptedSeed!);
        // Get prefix tag to determine how to choose decrypt method.
        Uint8List prefix = encryptedSeed.sublist(0, 8);
        if (MinaHelper.bytesToUtf8String(prefix) == 'Salted__' &&
            !_hasUpgradePopped) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            showUpgradeCihperDialog(context);
            _hasUpgradePopped = true;
          });
        }
      }

      if(globalHDAccounts.accounts != null && globalHDAccounts.accounts!.isNotEmpty) {
        _accountBloc!.add(GetAccounts(0));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print('WalletHomeScreen initState');
    WidgetsBinding.instance!.addObserver(this);
    _accountBloc = BlocProvider.of<AccountBloc>(context);
    _updateAccounts(newRoute: true);
    _eventBusOn = eventBus.on<UpdateAccounts>().listen((event) {
      _updateAccounts();
    });
  }

  @override
  void dispose() {
    _accountBloc = null;
    WidgetsBinding.instance!.removeObserver(this);
    _eventBusOn.cancel();
    _eventBusOn = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateAccounts();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    print('WalletHomeScreen: didPopNext()');
//    _updateAccounts();
  }

  @override
  void didPush() {
    super.didPush();
    print('WalletHomeScreen: didPush()');
  }

  @override
  void didPushNext() {
    final route = ModalRoute.of(context)!.settings.name;
    print('WalletHomeScreen didPushNext() route: $route');
  }

  @override
  void didPop() {
    final route = ModalRoute.of(context)!.settings.name;
    print('WalletHomeScreen didPop() route: $route');
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: Size(375, 812),
      orientation: Orientation.portrait
    );
    return _buildWalletHomeBody(context);
  }

  Widget _buildWalletHomeBody(BuildContext context) {
    if(_stakeEnabled) {
      return _buildStakedHome(context);
    }

    return _buildNoStakeHome();
  }

  _buildStakedHome(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: backgroundGradient
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(height: 8.h),
          _buildQRTipIcon(),
          Container(height: 35.h),
          _buildMinaLogo(),
          Container(height: 36.h),
          Text('MINA WALLET BALANCE', textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: Color(0xff757575))),
          Container(height: 1.h,),
          BlocBuilder<AccountBloc, AccountStates>(
            builder: (BuildContext context, AccountStates state) {
              if(state is GetAccountsFinished) {
                // // Save global accounts info
                // Map accountsJson = globalHDAccounts.toJson();
                // //globalPreferences.setString(GLOBAL_ACCOUNTS_KEY, json.encode(accountsJson));
                // globalSecureStorage.write(key: GLOBAL_ACCOUNTS_KEY, value: json.encode(accountsJson));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTotalBalance(),
                  _buildFiatBalance(),
                  Container(height: 23.h),
                  _buildStakedPercent(),
                ]
              );
            }
          ),
          Container(height: 43.h),
          _buildActionButton(context)
        ]
      ),
    );
  }

  _buildNoStakeHome() {
    return Column(children: [
      Expanded(child: Column(
        children: [
          Container(height: 8.h),
          _buildQRTipIcon(),
          Container(height: 2.h),
          _buildMinaLogo(),
          Container(height: 10.h),
          _buildTotalBalance(),
          _buildFiatBalance(),
          Container(height: 12.h),
          _buildActionButton(context)
        ]),
        flex: 5
      ),
      Expanded(child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.bottomCenter,
            image: AssetImage('images/no_staking_bg.png',),
            fit: BoxFit.fitWidth
          ),
        ),
        child: Center(
          child: Column(children: [
            Image.asset('images/to_stake_flower.png', width: 80.w, height: 80.w),
            Container(height: 24.h),
            Text('Earn returns on your hodlings', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500, color: Colors.white)),
            Container(height: 26.h),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 70.w, right: 70.w),
                decoration: getMinaButtonDecoration(),
                child: Text('START STAKING', style: TextStyle(color: Colors.black),),
              ),
              onTap: null,
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          )),
        ),
        flex: 4
      )
      ],
    );
  }

  _buildQRTipIcon() {
    return Row(
      children: [
        Expanded(child: Container(), flex: 1),
        Container(
          padding: EdgeInsets.all(10.w),
          width: 44.w,
          height: 44.w,
          child: InkWell(
            onTap: () => _gotoReceiveAccountsScreen(context),
            child: Image.asset('images/qr_code_icon.png')
          )
        ),
        Container(width: 28.w)
      ],
    );
  }

  _buildMinaLogo() {
    return Container(
      width: double.infinity,
      child: Center(
        child: Image.asset('images/mina_logo_inner.png', width: 80.w, height: 73.w,),
      )
    );
  }

  _buildTotalBalance() {
    return Padding(
      padding: EdgeInsets.only(top: 9.h, bottom: 9.h),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text: '${getWalletBalance()} ',
            style: TextStyle(fontSize: 30.sp, color: Colors.black, fontWeight: FontWeight.w500)),
          TextSpan(
            text: 'MINA',
            style: TextStyle(color: Color(0xff979797), fontWeight: FontWeight.normal, fontSize: 14.sp)),
          ]
        )
      )
    );
  }

  _buildFiatBalance() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
      child: Text('(\$${getWalletFiatPrice()})', textAlign: TextAlign.center, maxLines: 2,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400, color: Color(0xff757575)))
    );
  }

  _buildActionButton(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              child: Container(
                padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 6.h, bottom: 6.h),
                child: Text('SEND', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
              ),
              onTap: () => _gotoSendFromScreen(context),
            )
          ),
          Container(height: 32.67.h, width: 1.w, color: Color(0xffd3d3d3)),
          Expanded(
            flex: 1,
            child: InkWell(
              child: Container(
                padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 6.h, bottom: 6.h),
                child: Text('RECEIVE', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
              ),
              onTap: () => _gotoReceiveAccountsScreen(context)
            )
          ),
        ],
      ),
      width: 263.w,
      height: 49.h,
      decoration: getMinaButtonDecoration(),
//      margin: EdgeInsets.all(10),
    );
  }

  _buildStakedPercent() {
    double stakePercent = double.tryParse(getStakePercent()) ?? 0.0;
    return CircularPercentIndicator(
      radius: 82.w,
      lineWidth: 5.0,
      percent: stakePercent,
      backgroundColor: Color(0xff9e9e9e),
      center: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text: '${(stakePercent * 100).toStringAsFixed(1)}%\n',
            style: TextStyle(fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.w500)),
          TextSpan(
            text: 'STAKED',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 10.sp)),
          ]
        )
      ),
      progressColor: Color(0xffbfb556),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
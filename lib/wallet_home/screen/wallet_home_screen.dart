import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:coda_wallet/types/send_data.dart';
import 'package:coda_wallet/wallet_home/blocs/account_bloc.dart';
import 'package:coda_wallet/wallet_home/blocs/account_events.dart';
import 'package:coda_wallet/wallet_home/blocs/account_states.dart';
import 'package:coda_wallet/widget/dialog/unsafe_device_alert_dialog.dart';
import 'package:coda_wallet/widget/dialog/upgrade_cipher_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ffi_mina_signer/util/mina_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../util/format_utils.dart';

class WalletHomeScreen extends StatefulWidget {
  WalletHomeScreen({Key? key}) : super(key: key);

  @override
  _WalletHomeScreenState createState() => _WalletHomeScreenState();
}

class _WalletHomeScreenState extends State<WalletHomeScreen> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, RouteAware {
  AccountBloc? _accountBloc;
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showUpgradeCihperDialog(context);
            _hasUpgradePopped = true;
          });
        }
      }

      if(globalHDAccounts.accounts != null && globalHDAccounts.accounts!.isNotEmpty) {
        _accountBloc!.add(GetAccounts(true));
      }
    }
  }

  _unsafeDeviceDetect() async {
    late bool jailbroken;

    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
    } on PlatformException {
      jailbroken = false;
    }

    if(jailbroken) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showUnsafeDeviceAlertDialog(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print('WalletHomeScreen initState');
    WidgetsBinding.instance.addObserver(this);
    _accountBloc = BlocProvider.of<AccountBloc>(context);
    _updateAccounts(newRoute: true);
    _eventBusOn = eventBus.on<UpdateAccounts>().listen((event) {
      _updateAccounts();
    });
    // Warn user if this device is rooted or jailbroken
    _unsafeDeviceDetect();
  }

  @override
  void dispose() {
    _accountBloc = null;
    WidgetsBinding.instance.removeObserver(this);
    _eventBusOn.cancel();
    _eventBusOn = null;
    routeObserver.unsubscribe(this);
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
    super.build(context);
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true, splitScreenMode: false, scaleByHeight: false);
    return _buildStakedHome(context);
  }

  _buildStakedHome(BuildContext context) {
    return Container(
      color: Color(0xfff1f1f1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(height: 20.h),
          _buildHomeTitleBar(context),
          Container(height: 48.h),
          _buildMinaLogo(),
          Container(height: 20.h),
          Text('MINA WALLET ACCOUNT', textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: Color(0xff757575))),
          Container(height: 10.h),
          BlocBuilder<AccountBloc, AccountStates>(
            builder: (BuildContext context, AccountStates state) {
            return _buildAccountWidget(context);
            }
          ),
          Container(height: 20.h,),
          BlocBuilder<AccountBloc, AccountStates>(
            builder: (BuildContext context, AccountStates state) {
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
          BlocBuilder<AccountBloc, AccountStates>(
            builder: (BuildContext context, AccountStates state) {
              return _buildActionButton(context, state);
            }
          )
        ]
      )
    );
  }

  _buildWalletSync(BuildContext context, AccountStates state) {
    if(state is GetAccountsLoading) {
      return LoadingAnimationWidget.flickr(
        leftDotColor: Colors.purple,
        rightDotColor: Colors.blueAccent,
        size: 26.w);
    }

    if(state is GetAccountsFail) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync accounts failed!')));
      });
      return OutlinedButton(
        onPressed: () {
          _accountBloc!.add(GetAccounts(true));
        },
        child: Text('RESYNC', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xfffe5962))),
        style: OutlinedButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
          backgroundColor: Color(0xdddddd),
          foregroundColor: Colors.redAccent,
          side: BorderSide(width: 0.5.h, color: Colors.redAccent,),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          padding: EdgeInsets.fromLTRB(6.w, 6.h, 6.w, 6.h)
        ),
      );
    }

    return Container();
  }

  _buildHomeTitleBar(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(width: 24.w,),
        BlocBuilder<AccountBloc, AccountStates>(
          builder: (BuildContext context, AccountStates state) {
            return Expanded(
              child:_buildAccountSwitcher(context, state)
            );
          }
        ),
        Container(width: 120.w,),
        BlocBuilder<AccountBloc, AccountStates>(
          builder: (BuildContext context, AccountStates state) {
            return _buildWalletSync(context, state);
          }
        ),
        Container(width: 28.w)
      ],
    );
  }

  _buildAccountSwitcher(BuildContext context, AccountStates state) {
    void Function(Object?)? onChangedCallback;
    if(state is GetAccountsLoading) {
      onChangedCallback = null;
    } else {
      onChangedCallback = (value) {
        AccountBean accountBean = value as AccountBean;
        if(accountBean.account != _accountBloc!.accountIndex) {
          _accountBloc!.accountIndex = accountBean.account!;
          _accountBloc!.add(GetAccounts(false));
        }
      };
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Container(
          padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('images/account_list.png', width: 20.w, height: 20.w,),
              Container(width: 1.w),
              Text('ACCOUNTS', textAlign: TextAlign.left,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d)),),
            ],
          ),
        ),
        items: _buildAccountsDropItems(context),
        onChanged: onChangedCallback,
      ),
    );
  }

  _buildAccountsDropItems(BuildContext context) {
    return globalHDAccounts.accounts!.map<DropdownMenuItem<AccountBean>>((AccountBean? value) {
      Widget accountItem;
      Color itemColor;
      if(_accountBloc!.accountIndex == value!.account) {
        accountItem = Image.asset('images/selected.png', width: 14.w, height: 14.w,);
        itemColor = Color(0xff098de6);
      } else {
        accountItem = Container(width: 12.w, height: 12.w,);
        itemColor = Color(0xff2d2d2d);
      }

      return DropdownMenuItem<AccountBean>(
        value: value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            accountItem,
            Container(width: 4.w,),
            Text(_getShortAccountName(value.accountName, 16),
              textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: itemColor)),
          ],
        )
      );
    }).toList();
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
    bool isActive = globalHDAccounts.accounts?[_accountBloc!.accountIndex]!.isActive ?? false;

    if(isActive) {
      return Padding(
        padding: EdgeInsets.only(top: 9.h, bottom: 1.h),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '${MinaHelper.getMinaStrByNanoStr(
                  globalHDAccounts.accounts?[_accountBloc!.accountIndex]!.balance ?? '')} ',
                style: TextStyle(fontSize: 30.sp, color: Colors.black, fontWeight: FontWeight.w500)),
              TextSpan(
                text: 'MINA',
                style: TextStyle(color: Color(0xff979797), fontWeight: FontWeight.normal, fontSize: 14.sp)),
            ]
          )
        )
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 9.h, bottom: 1.h),
        child: Text('Inactive account', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500, color: Color(0xfffe5962)),)
      );
    }
  }

  _buildFiatBalance() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
      child: Text('(\$${getAccountFiatPrice(_accountBloc!.accountIndex)})', textAlign: TextAlign.center, maxLines: 2,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w400, color: Color(0xff757575)))
    );
  }

  _buildActionButton(BuildContext context, AccountStates state) {
    Color sendColor;
    Color receiveColor;
    void Function()? sendCallback;
    void Function()? receiveCallback;

    if(state is GetAccountsSuccess) {
      sendColor = Color(0xff098de6);
      receiveColor = Color(0xff01c6d0);
      sendCallback = () {
        SendData sendData = SendData();
        sendData.isDelegation = false;
        sendData.from = _accountBloc!.accountIndex;
        Navigator.of(context).pushNamed(SendToRoute, arguments: sendData);
      };
      receiveCallback = () =>
        Navigator.of(context).pushNamed(ReceiveAccountRoute, arguments: _accountBloc!.accountIndex);;
    } else {
      sendColor = Color(0xff979797);
      receiveColor = Color(0xff979797);
      sendCallback = null;
      receiveCallback = null;
    }

    return Container(
      width: 300.w,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 1.w),
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(color: Colors.black12,
            offset: Offset(0, 0), blurRadius: 1, spreadRadius: 0.5)
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.w),
                  borderRadius: BorderRadius.all(Radius.circular(8.w)),
                  color: Color(0xffffffff),
                ),
                padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 14.h, bottom: 14.h),
                child: Text('SEND', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: sendColor),),
              ),
              onTap: sendCallback
            )
          ),
          Container(height: 32.67.h, width: 1.w, color: Color(0xffd3d3d3)),
          Expanded(
            flex: 1,
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.w),
                  borderRadius: BorderRadius.all(Radius.circular(8.w)),
                  color: Color(0xffffffff),
                ),
                padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 14.h, bottom: 14.h),
                child: Text('RECEIVE', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: receiveColor),),
              ),
              onTap: receiveCallback
            )
          ),
        ],
      ),
    );
  }

  _buildAccountWidget(BuildContext context) {
    String shortAccountName =
      _getShortAccountName(globalHDAccounts.accounts?[_accountBloc!.accountIndex]?.accountName, 24);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 50.w, right: 50.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/account_need_sync.png', width: 16.w, height: 16.w,),
              Container(width: 2.w,),
              Text(shortAccountName,
                textAlign: TextAlign.left, overflow: TextOverflow.ellipsis, maxLines: 1,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
            ],
          )
        ),
        Container(height: 2.h,),
        Text(
          '${formatHashEllipsis(_accountBloc!.publicKey, short: false)}', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300, color: Color(0xff979797))
        ),
      ],
    );
  }

  _buildStakedPercent() {
    return CircularPercentIndicator(
      radius: 82.w,
      lineWidth: 5.0,
      percent: _accountBloc!.accountStaking ? 1.0 : 0.0,
      backgroundColor: Color(0xff9e9e9e),
      center: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text: _accountBloc!.accountStaking ? '100%\n' : '0.00%\n',
            style: TextStyle(fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.w500)),
          TextSpan(
            text: 'STAKED',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 10.sp)),
          ]
        )
      ),
      progressColor: Color(0xff6bc7a1),
    );
  }

  String _getShortAccountName(String? accountName, int length) {
    if(null == accountName || accountName.isEmpty) {
      return 'null';
    }

    if(accountName.length >= length) {
      return accountName.substring(0, length) + '...';
    }

    return accountName;
  }

  @override
  bool get wantKeepAlive => true;
}

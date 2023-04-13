import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/screen_record_detector/screen_record_detector.dart';
import 'package:coda_wallet/setting/setting_screen.dart';
import 'package:coda_wallet/stake/blocs/stake_center_bloc.dart';
import 'package:coda_wallet/stake/blocs/stake_center_states.dart';
import 'package:coda_wallet/stake/screen/stake_center_screen.dart';
import 'package:coda_wallet/txns/blocs/txns_bloc.dart';
import 'package:coda_wallet/txns/blocs/txns_states.dart';
import 'package:coda_wallet/txns/screen/txns_screen.dart';
import 'package:coda_wallet/wallet_home/blocs/account_bloc.dart';
import 'package:coda_wallet/wallet_home/blocs/account_states.dart';
import 'package:coda_wallet/wallet_home/screen/wallet_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constant/constants.dart';

class EntrySheet extends StatefulWidget {
  EntrySheet();

  @override
  _EntrySheetState createState() => _EntrySheetState();
}

class _EntrySheetState extends State<EntrySheet> with SingleTickerProviderStateMixin, ScreenRecordDetector {

  int _currentIndex = 0;
  late List<BottomNavigationBarItem> _bottomBarItems;
  final List<Widget> _entryTabs = [
    BlocProvider<AccountBloc>(
      create: (BuildContext context) {
        return AccountBloc(GetAccountsLoading());
      },
      child: WalletHomeScreen()
    ),
    BlocProvider<StakeCenterBloc>(
      create: (BuildContext context) {
        return StakeCenterBloc(GetStakeStatusLoading());
      },
      child: StakeCenterScreen()
    ),
    BlocProvider<TxnsBloc>(
      create: (BuildContext context) {
        return TxnsBloc(RefreshTxnsLoading(null));
      },
      child: TxnsScreen()
    ),
    SettingScreen(),
  ];

  final _pageController = PageController();

  void _onTap(int index) {
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    if(0 == index) {
      eventBus.fire(UpdateAccounts());
    }

    if(1 == index) {
      eventBus.fire(UpdateStake());
    }

    if(2 == index) {
      eventBus.fire(UpdateTxns());
    }

    setState(() {
      _currentIndex = index;
    });
  }

  _initBottomBarItems() {
    _bottomBarItems = [
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Image.asset("images/wallet_tab_unselected.png",
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.h),
        ),
        activeIcon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Image.asset("images/wallet_tab_selected.png",
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.h),
        ),
        label: 'Wallet',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Image.asset("images/stake_tab_unselected.png",
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.h),
        ),
        activeIcon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Image.asset("images/stake_tab_selected.png",
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.h)),
        label:'Stake'
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Image.asset("images/txns_tab_unselected.png",
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.h),
        ),
        activeIcon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Image.asset("images/txns_tab_selected.png",
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.h),
        ),
        label:'Transaction'
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Image.asset("images/settings_tab_unselected.png",
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.h),
        ),
        activeIcon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Image.asset("images/settings_tab_selected.png",
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.h),
        ),
        label:'Setting'
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    // Default, this app can take screenshots, except key sensitive pages
    super.dismissDetector();
    print('EntrySheet initState');
  }

  @override
  void dispose() {
    _pageController.dispose();
    print('EntrySheet dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('EntrySheet build');
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true, splitScreenMode: false, scaleByHeight: false);
    _initBottomBarItems();
    return Scaffold(
      backgroundColor: Color(0xfffdfdfd),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _entryTabs,
          physics: NeverScrollableScrollPhysics()
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: _bottomBarItems,
        selectedFontSize: 12.sp,
        unselectedFontSize: 12.sp,
        iconSize: 24.h,
        onTap: _onTap,
        fixedColor: Color(0xff6bc7a1),
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.sp),
      )
    );
  }
}

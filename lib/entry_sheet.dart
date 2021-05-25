import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/setting/setting_screen.dart';
import 'package:coda_wallet/stake/blocs/stake_bloc.dart';
import 'package:coda_wallet/stake/blocs/stake_states.dart';
import 'package:coda_wallet/stake/screen/stake_screen.dart';
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

class _EntrySheetState extends State<EntrySheet> with SingleTickerProviderStateMixin {

  int _currentIndex = 0;
  late List<BottomNavigationBarItem> _bottomBarItems;
  final List<Widget> _entryTabs = [
    BlocProvider<AccountBloc>(
      create: (BuildContext context) {
        return AccountBloc(GetAccountsLoading());
      },
      child: WalletHomeScreen()
    ),
    BlocProvider<StakeBloc>(
      create: (BuildContext context) {
        return StakeBloc(GetConsensusStateLoading(null));
      },
      child: StakeScreen()
    ),
    BlocProvider<TxnsBloc>(
      create: (BuildContext context) {
        return TxnsBloc(RefreshPooledTxnsLoading(null));
      },
      child: TxnsScreen()
    ),
    SettingScreen(),
  ];

  final _pageController = PageController();

  void onTap(int index) {
    if(0 == index) {
      eventBus.fire(UpdateAccounts());
    }

    if(1 == index) {
      eventBus.fire(UpdateTxns());
    }
    _pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
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
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w),
        ),
        activeIcon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Image.asset("images/wallet_tab_selected.png",
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w),
        ),
        label: 'Wallet',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Image.asset("images/stake_tab_unselected.png",
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w),
        ),
        activeIcon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Image.asset("images/stake_tab_selected.png",
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w)),
        label:'Stake'
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Image.asset("images/txns_tab_unselected.png",
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w),
        ),
        activeIcon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Image.asset("images/txns_tab_selected.png",
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w),
        ),
        label:'Transactions'
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Image.asset("images/settings_tab_unselected.png",
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w),
        ),
        activeIcon: Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Image.asset("images/settings_tab_selected.png",
            fit: BoxFit.contain, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w),
        ),
        label:'Settings'
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
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
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: Size(375, 812),
      orientation: Orientation.portrait
    );
    _initBottomBarItems();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
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
        onTap: onTap,
        fixedColor: Colors.red,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      )
    );
  }
}

import 'package:coda_wallet/setting/setting_screen.dart';
import 'package:coda_wallet/stake/screen/stake_screen.dart';
import 'package:coda_wallet/txns/blocs/txns_bloc.dart';
import 'package:coda_wallet/txns/blocs/txns_states.dart';
import 'package:coda_wallet/txns/screen/txns_screen.dart';
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
  List<BottomNavigationBarItem> _bottomBarItems;
  final List<Widget> _entryTabs = [
    WalletHomeScreen(),
    StakeScreen(),
    BlocProvider<TxnsBloc>(
      create: (BuildContext context) {
        return TxnsBloc(RefreshTxnsLoading(null));
      },
      child: TxnsScreen()
    ),
    SettingScreen(),
  ];

  final _pageController = PageController();

  void onTap(int index) {
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
        icon: Image.asset("images/txsend.png",
            fit: BoxFit.cover, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w),
        activeIcon: Image.asset("images/txreceive.png",
            fit: BoxFit.cover, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w),
        label: 'Wallet',
      ),
      BottomNavigationBarItem(
        icon: Image.asset("images/txsend.png",
            fit: BoxFit.cover, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w),
        activeIcon: Image.asset("images/txreceive.png",
            fit: BoxFit.cover, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w),
        label:'Stake'
      ),
      BottomNavigationBarItem(
        icon: Image.asset("images/txsend.png",
            fit: BoxFit.cover, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w),
        activeIcon: Image.asset("images/txreceive.png",
            fit: BoxFit.cover, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w),
        label:'Transaction'
      ),
      BottomNavigationBarItem(
        icon: Image.asset("images/txsend.png",
            fit: BoxFit.cover, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w),
        activeIcon: Image.asset("images/txreceive.png",
            fit: BoxFit.cover, width: BOTTOM_BAR_ITEM_SIZE.w, height: BOTTOM_BAR_ITEM_SIZE.w),
        label:'Setting'
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('EntrySheet build');
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    _initBottomBarItems();
    return Scaffold(
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
        selectedFontSize: 15.sp,
        unselectedFontSize: 15.sp,
        onTap: onTap,
        fixedColor: Colors.green,
      )
    );
  }
}

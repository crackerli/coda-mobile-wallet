import 'package:coda_wallet/send/blocs/send_bloc.dart';
import 'package:coda_wallet/stake/screen/stake_screen.dart';
import 'package:coda_wallet/txns/blocs/txns_bloc.dart';
import 'package:coda_wallet/txns/blocs/txns_states.dart';
import 'package:coda_wallet/txns/screen/txns_screen.dart';
import 'package:coda_wallet/wallet_home/screen/wallet_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EntrySheet extends StatefulWidget {
  EntrySheet();

  @override
  _EntrySheetState createState() => _EntrySheetState();
}

class _EntrySheetState extends State<EntrySheet> with SingleTickerProviderStateMixin {

  int _currentIndex = 0;
  var _currentPage;
  num _bottomBarItemSize;
  List<BottomNavigationBarItem> _bottomBarItems;
  final List _tabs = [
    WalletHomeScreen(),
    StakeScreen(),
    BlocProvider<TxnsBloc>(
      create: (BuildContext context) {
        return TxnsBloc(RefreshTxnsLoading(null), 'B62qrPN5Y5yq8kGE3FbVKbGTdTAJNdtNtB5sNVpxyRwWGcDEhpMzc8g');
      },
      child: TxnsScreen()
    ),
    ChildItemView("Fourth"),
  ];

  _initBottomBarItems() {
    _bottomBarItems = [
      BottomNavigationBarItem(
        icon: Image.asset("images/txsend.png",
            fit: BoxFit.cover, width: _bottomBarItemSize, height: _bottomBarItemSize),
        activeIcon: Image.asset("images/txreceive.png",
            fit: BoxFit.cover, width: _bottomBarItemSize, height: _bottomBarItemSize),
        label: 'Wallet',
      ),
      BottomNavigationBarItem(
        icon: Image.asset("images/txsend.png",
            fit: BoxFit.cover, width: _bottomBarItemSize, height: _bottomBarItemSize),
        activeIcon: Image.asset("images/txreceive.png",
            fit: BoxFit.cover, width: _bottomBarItemSize, height: _bottomBarItemSize),
        label:'Stake'
      ),
      BottomNavigationBarItem(
        icon: Image.asset("images/txsend.png",
            fit: BoxFit.cover, width: _bottomBarItemSize, height: _bottomBarItemSize),
        activeIcon: Image.asset("images/txreceive.png",
            fit: BoxFit.cover, width: _bottomBarItemSize, height: _bottomBarItemSize),
        label:'Transaction'
      ),
      BottomNavigationBarItem(
        icon: Image.asset("images/txsend.png",
            fit: BoxFit.cover, width: _bottomBarItemSize, height: _bottomBarItemSize),
        activeIcon: Image.asset("images/txreceive.png",
            fit: BoxFit.cover, width: _bottomBarItemSize, height: _bottomBarItemSize),
        label:'Setting'
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _currentPage = _tabs[_currentIndex];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    _bottomBarItemSize = 26.w;
    _initBottomBarItems();
    return Scaffold(
      body: SafeArea(child: _currentPage),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: _bottomBarItems,
        selectedFontSize: 15.sp,
        unselectedFontSize: 15.sp,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _currentPage = _tabs[_currentIndex];
            }
            );
          },
          fixedColor: Colors.green,
        )
    );
  }
}

//子页面
class ChildItemView extends StatefulWidget {
  String _title;

  ChildItemView(this._title);

  @override
  _ChildItemViewState createState() => _ChildItemViewState();
}

class _ChildItemViewState extends State<ChildItemView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text(widget._title)),
    );
  }
}
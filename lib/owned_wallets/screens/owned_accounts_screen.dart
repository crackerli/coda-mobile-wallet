import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_entity.dart';
import 'package:coda_wallet/owned_wallets/screens/owned_accounts_dialog.dart';
import 'package:coda_wallet/util/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../blocs/owned_accounts_bloc.dart';
import '../blocs/owned_accounts_events.dart';
import '../blocs/owned_accounts_states.dart';
import '../../util/format_utils.dart';
import '../query/owned_accounts_query.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnedAccountsScreen extends StatefulWidget {
  OwnedAccountsScreen({Key key}) : super(key: key);

  @override
  _OwnedAccountsScreenState
    createState() => _OwnedAccountsScreenState();
}

class _OwnedAccountsScreenState extends State<OwnedAccountsScreen> {
  OwnedAccountsBloc _ownedAccountsBloc;

  @override
  void initState() {
    _ownedAccountsBloc = BlocProvider.of<OwnedAccountsBloc>(context);
    _ownedAccountsBloc.add(FetchOwnedAccounts(OWNED_ACCOUNTS_QUERY));
    super.initState();
  }

  @override
  void dispose() {
    _ownedAccountsBloc = null;
    super.dispose();
  }


  Future<Null> _onRefresh() async {
    if(!_ownedAccountsBloc.isAccountLoading) {
      _ownedAccountsBloc.add(FetchOwnedAccounts(OWNED_ACCOUNTS_QUERY));
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(1080, 2316), allowFontScaling: false);
    return Scaffold(
      appBar: _buildAccountsAppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocBuilder<OwnedAccountsBloc, OwnedAccountsStates>(
          builder: (BuildContext context, OwnedAccountsStates state) {
            return _buildAccountsBody(context, state);
          }
        )
      ),
      floatingActionButton: _buildActionButton(),
    );
  }

  Widget _buildAccountsAppBar() {
    return PreferredSize(
      child: AppBar(
        title: Text('Accounts',
          style: TextStyle(fontSize: APPBAR_TITLE_FONT_SIZE.sp, color: Color(0xff0b0f12))),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Image.asset('images/setting.png', width: 100.w, height: 100.w),
            tooltip: 'Setting',
            iconSize: 24,
            onPressed: () => toSettingScreen(context),
          )
        ]
      ),
      preferredSize: Size.fromHeight(APPBAR_HEIGHT.h)
    );
  }

  Widget _buildActionButton() {
    return SpeedDial(
        child: Icon(Icons.add),
        children:[
          SpeedDialChild(
              child: Icon(Icons.create),
              backgroundColor: Colors.red,
              label: 'Create',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => showCreateAccountDialog(context)
          ),
          SpeedDialChild(
            label: 'Delete',
            child: Icon(Icons.delete),
            backgroundColor: Colors.orange,
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: null,
          ),
        ]
    );
  }

  Widget _buildAccountsBody(BuildContext context, OwnedAccountsStates state) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(height: 8, color: Color(0xffeeeeee)),
        Container(height: 6,),
        Expanded(
          flex: 1,
          child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: _buildAccountsWidget(context, state))
        )
      ],
    );
  }

  Widget _buildAccountsWidget(
    BuildContext context, OwnedAccountsStates state) {

    if(state is FetchOwnedAccountsLoading) {
      List<Account> data = state.data as List;
      if(null == data || 0 == data.length) {
        return Center(
            child: CircularProgressIndicator()
        );
      }
      return _buildAccountListWidget(data);
    }

    if(state is FetchOwnedAccountsFail) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.error),
            RaisedButton(
              padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 80, right: 80),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
              onPressed: () => _ownedAccountsBloc.add(FetchOwnedAccounts(OWNED_ACCOUNTS_QUERY)),
              color: Colors.blueAccent,
              child: Text('Refresh', style: TextStyle(color: Colors.white),)
            )
          ]
        )
      );
    }

    if(state is FetchOwnedAccountsSuccess) {
      List<Account> data = state.data as List;
      return _buildAccountListWidget(data);
    }

    if(state is ToggleLockStatusFail) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final snackBar = SnackBar(content: Text('Lock Account Failed: ${state.error}'));
        Scaffold.of(context).showSnackBar(snackBar);
      });
      return Container();
    }

    if(state is ToggleLockStatusSuccess) {
      List<Account> data = state.data as List;
      return _buildAccountListWidget(data);
    }

    if(state is CreateAccountSuccess) {
      List<Account> data = state.data as List;
      return _buildAccountListWidget(data);
    }

    return Container();
  }
  
  _accountsTapCallback(BuildContext context, Account account) {
    toAccountTxnsScreen(context, account);
  }

  _buildAccountContent(BuildContext context, Account account) {
    String publicKey = account.publicKey;
    String formattedTokenNumber = formatTokenNumber(account.balance);

    return Column(
      children: [
        _publicKeyText(publicKey),
        Container(height: 10),
        Container(height: 1, color: Colors.grey),
        Container(height: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 1,child: Text("Balance: $formattedTokenNumber")),
            Container(width: 10),
            GestureDetector(
              child: _lockStatusImage(account.locked),
              onTap: () { _clickLock(context, account); }
            ),
            Container(width: 10),
            GestureDetector(
                child: Image.asset('images/delete.png', width: 16, height: 16),
                onTap: () { _clickLock(context, account); }
            )
          ]
        )
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max
    );
  }

  Widget _buildAccountItem(
    BuildContext context, Account itemData) {

    return GestureDetector(
      onTap: () { _accountsTapCallback(context, itemData); },
      child: Card(
        elevation: 4.0,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(left: 14.0, right: 14.0, top: 12, bottom: 8),
          child: _buildAccountContent(context, itemData)
        )
      )
    );
  }

  _publicKeyText(String publicKey) {
    return Text(publicKey, softWrap: true,
      textAlign: TextAlign.left, overflow: TextOverflow.ellipsis, maxLines: 3);
  }

  _lockStatusImage(bool locked) {
    return Image.asset(locked ?
        'images/locked_black.png' : 'images/unlocked_green.png', width: 16, height: 16);
  }

  _clickLock(BuildContext context, Account account) {
    if(null == account) {
      return;
    }

    if(account.locked) {
      showUnlockAccountDialog(context, account);
      return;
    }

    if(!account.locked) {
      showLockAccountDialog(context, account);
    }
  }

  Widget _buildAccountListWidget(List<Account> accountList) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: accountList.length,
      itemBuilder: (context, index) {
        return _buildAccountItem(context, accountList[index]);
      },
      separatorBuilder: (context, index) { return Container(); }
    );
  }
}


import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_models.dart';
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

  @override
  void initState() {
    final _ownedAccountsBloc = BlocProvider.of<OwnedAccountsBloc>(context);
    _ownedAccountsBloc.add(FetchOwnedAccounts(OWNED_ACCOUNTS_QUERY));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(1080, 2316), allowFontScaling: false);
    return Scaffold(
      appBar: _buildAccountsAppBar(),
      body: BlocBuilder<OwnedAccountsBloc, OwnedAccountsStates>(
        builder: (BuildContext context, OwnedAccountsStates state) {
          return _buildAccountsBody(context, state);
        }
      ),
      floatingActionButton: _buildActionButton(),
    );
  }

  _gotoSetting() {

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
            tooltip: 'QrCode',
            iconSize: 24,
            onPressed: _gotoSetting,
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
              onTap: null
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
        Expanded(flex: 1,
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
      return Center(
        child: CircularProgressIndicator()
      );
    }

    if(state is FetchOwnedAccountsFail) {
      return Center(child: Text(state.error));
    }

    if(state is FetchOwnedAccountsSuccess) {
      List<Account> data = state.data as List;
      return _buildAccountListWidget(data);
    }

    if(state is ToggleLockStatusFail) {
      final snackBar = SnackBar(content: Text('Lock Account Failed'));
      Scaffold.of(context).showSnackBar(snackBar);
      return Container();
    }

    if(state is ToggleLockStatusSuccess) {
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
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Balance: $formattedTokenNumber"),
            Container(width: 10, height: 1),
            GestureDetector(
              child: _lockStatusImage(account.locked),
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
    return Container(
      margin: EdgeInsets.only(left: 0, top: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: Text(publicKey, softWrap: true,
          textAlign: TextAlign.left, overflow: TextOverflow.ellipsis, maxLines: 3)
    );
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
      itemCount: accountList.length,
      itemBuilder: (context, index) {
        return _buildAccountItem(context, accountList[index]);
      },
      separatorBuilder: (context, index) { return Container(); }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}


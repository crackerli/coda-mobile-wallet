import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_models.dart';
import 'package:coda_wallet/owned_wallets/screens/owned_accounts_dialog.dart';
import 'package:coda_wallet/util/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/owned_accounts_bloc.dart';
import '../blocs/owned_accounts_events.dart';
import '../blocs/owned_accounts_states.dart';
import '../../util/format_utils.dart';
import '../query/owned_accounts_query.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text('My Accounts')),
      body: BlocBuilder<OwnedAccountsBloc, OwnedAccountsStates>(
        builder: (BuildContext context, OwnedAccountsStates state) {
          return _buildAccountsWidget(context, state);
        }
      )
    );
  }

  Widget _buildAccountsWidget(
    BuildContext context, OwnedAccountsStates state) {

    if(state is FetchOwnedAccountsLoading) {
      return LinearProgressIndicator();
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
  
  _accountsTapCallback(BuildContext context, String publicKey) {
    toAccountTxnsScreen(context, publicKey);
  }

  _buildAccountContent(BuildContext context, Account content) {
    String publicKey = content.publicKey;
    String formattedTokenNumber = formatTokenNumber(content.balance);

    return Column(
      children: [
        _publicKeyText(publicKey),
        Container(height: 10),
        Row(
          children: [
            Text("Token: $formattedTokenNumber"),
            Container(width: 10, height: 1),
            GestureDetector(
              child: _lockStatusImage(content.locked),
              onTap: () { _clickLock(context, content); }
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

    String publicKey = itemData.publicKey;

    return GestureDetector(
      onTap: () { _accountsTapCallback(context, publicKey); },
      child: Container(
        padding: EdgeInsets.only(left: 14.0, right: 14.0, top: 6.0, bottom: 1.0),
        child: _buildAccountContent(context, itemData)
      )
    );
  }

  _publicKeyText(String publicKey) {
    return Text(publicKey, softWrap: true,
        textAlign: TextAlign.left, overflow: TextOverflow.ellipsis, maxLines: 1);
  }

  _lockStatusImage(bool locked) {
    return Image.asset(locked ?
        'images/lock.png' : 'images/unlock.png', width: 16, height: 16);
  }

  _clickLock(BuildContext context, Account content) {
    showUnlockAccountDialog(context, content);
  }

  Widget _buildAccountListWidget(List<Account> accountList) {
    return ListView.separated(
      itemCount: accountList.length,
      itemBuilder: (context, index) {
        return _buildAccountItem(context, accountList[index]);
      },
      separatorBuilder: (context, index) { return Divider(); }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}


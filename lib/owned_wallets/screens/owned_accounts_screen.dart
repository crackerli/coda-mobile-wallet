import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_models.dart';
import 'package:coda_wallet/owned_wallets/mutation/owned_accounts_mutation.dart';
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

  Widget _buildAppBar() {
    return AppBar(title: Text('My Accounts'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnedAccountsBloc, OwnedAccountsStates>(
        builder: (BuildContext context, OwnedAccountsStates state) {
          return _buildAccountsWidget(context, state);
        }
    );
  }

  Widget _buildAccountsWidget(
    BuildContext context, OwnedAccountsStates state) {

    if(state is FetchOwnedAccountsLoading) {
      return Scaffold(appBar: _buildAppBar(), body: LinearProgressIndicator());
    }

    if(state is FetchOwnedAccountsFail) {
      return Scaffold(appBar: _buildAppBar(), body: Center(child: Text(state.error)));
    }

    if(state is FetchOwnedAccountsSuccess) {
      List<Account> data = state.data as List;
      return Scaffold(appBar: _buildAppBar(), body: _buildAccountListWidget(data));
    }

    if(state is LockAccountSuccess) {
      print('CK: ${state.data}');
      List<Account> data = state.data as List;
      return Scaffold(appBar: _buildAppBar(), body: _buildAccountListWidget(data));
    }

    return Container();
  }
  
  _accountsTapCallback(BuildContext context, String publicKey) {
    toAccountTxnsScreen(context, publicKey);
  }

  Widget _buildAccountItem(BuildContext context, Account itemData) {
    String publicKey = itemData.publicKey;
    String formattedTokenNumber = formatTokenNumber(itemData.balance);
    return GestureDetector(
      onTap: () {
        _accountsTapCallback(context, publicKey);
      },
      child: Container(
        padding: EdgeInsets.only(left: 14.0, right: 14.0, top: 6.0, bottom: 1.0),
        child: Column(
          children: [
            _publicKeyText(publicKey),
            Container(height: 10),
            Row(
              children: [
                Text("Token: $formattedTokenNumber"),
                Container(width: 10, height: 1),
                GestureDetector(
                  child: _lockStatusImage(itemData.locked),
                  onTap: () { _clickLock(context); }
                )
              ]
            )
          ],
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
        )
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

  _clickLock(BuildContext context) {
    Map<String, String> variables = Map<String, String>();
    variables['publicKey'] = 'B62qrPN5Y5yq8kGE3FbVKbGTdTAJNdtNtB5sNVpxyRwWGcDEhpMzc8g';
    variables['password'] = '';
    final _ownedAccountsBloc = BlocProvider.of<OwnedAccountsBloc>(context);
    _ownedAccountsBloc.add(LockAccount(ACCOUNT_UNLOCK_MUTATION, variables: variables));
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


import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_models.dart';
import 'package:coda_wallet/owned_wallets/mutation/owned_accounts_mutation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/owned_accounts_bloc.dart';
import '../blocs/owned_accounts_events.dart';
import '../blocs/owned_accounts_states.dart';
import '../../account_txns/screens/account_txns_screen.dart';
import '../../account_txns/blocs/account_txns_bloc.dart';
import '../../account_txns/blocs/account_txns_events.dart';
import '../../account_txns/query/account_txns_query.dart';
import '../../account_txns/blocs/account_txns_states.dart' as AccountStates;
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
  
  _accountsTapCallback(String publicKey) {
    Map<String, dynamic> variables = Map<String, dynamic>();
    variables['publicKey'] = publicKey;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return BlocProvider<AccountTxnsBloc>(
              create: (BuildContext context) {
                return AccountTxnsBloc(AccountStates.Loading())
                  ..add(FetchAccountTxnsData(ACCOUNT_TXNS_QUERY, variables: variables));
              },
              child: AccountTxnsScreen(publicKey)
          );
        }));
  }

  Widget _buildAccountItem(BuildContext context, Account itemData) {
    String publicKey = itemData.publicKey;
    String formattedTokenNumber = formatTokenNumber(itemData.balance);
    return Container(
      padding: EdgeInsets.only(left: 14.0, right: 14.0, top: 6.0, bottom: 1.0),
      child: Column(
        children: [
          Text(publicKey, softWrap: true, textAlign: TextAlign.left, overflow: TextOverflow.ellipsis, maxLines: 1),
          Container(height: 10),
          Row(
            children: [
              Text("Token: $formattedTokenNumber"),
              Container(width: 10, height: 1),
              GestureDetector(
                child: Image.asset(itemData.locked ? 'images/lock.png' : 'images/unlock.png', width: 16, height: 16),
                onTap: () {
                  final snackBar = new SnackBar(content: new Text('这是一个SnackBar!'));
                  Scaffold.of(context).showSnackBar(snackBar);
                  Map<String, String> variables = Map<String, String>();
                  variables['publicKey'] = 'B62qrPN5Y5yq8kGE3FbVKbGTdTAJNdtNtB5sNVpxyRwWGcDEhpMzc8g';
                  variables['password'] = '';
                  final _ownedAccountsBloc = BlocProvider.of<OwnedAccountsBloc>(context);
                  _ownedAccountsBloc.add(LockAccount(ACCOUNT_UNLOCK_MUTATION, variables: variables));
                },
              )
            ]
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
      )
    );
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

class OwnedAccountList extends StatelessWidget {
  final OwnedAccountsBloc _ownedAccountsBloc;

  const OwnedAccountList(Key key, this._ownedAccountsBloc) : super(key: key);

  @override
  Widget build(BuildContext context) {

  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/owned_accounts_bloc.dart';
import '../blocs/owned_accounts_states.dart';
import '../../account_txns/screens/account_txns_screen.dart';
import '../../account_txns/blocs/account_txns_bloc.dart';
import '../../account_txns/blocs/account_txns_events.dart';
import '../../account_txns/query/account_txns_query.dart';
import '../../account_txns/blocs/account_txns_states.dart' as AccountStates;

class OwnedAccountsScreen extends StatefulWidget {
  OwnedAccountsScreen({Key key}) : super(key: key);

  @override
  _OwnedAccountsScreenState createState() => _OwnedAccountsScreenState();
}

class _OwnedAccountsScreenState extends State<OwnedAccountsScreen> {

  @override
  void initState() {
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

  Widget _buildAccountsWidget(BuildContext context, OwnedAccountsStates state) {
    if(state is Loading) {
      return Scaffold(appBar: _buildAppBar(), body: LinearProgressIndicator());
    } else if(state is LoadDataFail) {
      return Scaffold(appBar: _buildAppBar(), body: Center(child: Text(state.error)));
    } else {
      dynamic data = (state as LoadDataSuccess).data['ownedWallets'];
      return Scaffold(appBar: _buildAppBar(), body: _buildAccountListWidget(data));
    }
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

  Widget _buildAccountItem(BuildContext context, dynamic itemData) {
    String publicKey = itemData['publicKey'];
    return Container(
      padding: EdgeInsets.only(left: 14.0, right: 14.0, top: 6.0, bottom: 1.0),
      child: Column(
        children: [
          Text(publicKey, softWrap: true, textAlign: TextAlign.left, overflow: TextOverflow.ellipsis, maxLines: 1),
          Container(height: 10),
          Row(
            children: [
              Text("Token: 19856"),
              Container(width: 10, height: 1),
              Image.asset("images/coda_logo.png", width: 16, height: 16)
            ]
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
      )
    );
  }

  Widget _buildAccountListWidget(dynamic data) {
    List ownedAccounts = data as List;
    return ListView.separated(
      itemCount: ownedAccounts.length,
      itemBuilder: (context, index) {
        String publicKey = ownedAccounts[index]['publicKey'];

        // return ListTile(
        //     title: Text(publicKey),
        //     onTap: () { _accountsTapCallback(publicKey); }
        // );
        return _buildAccountItem(context, ownedAccounts[index]);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

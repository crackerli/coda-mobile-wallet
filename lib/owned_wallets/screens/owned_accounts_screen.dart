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

  @override
  void dispose() {
    super.dispose();
  }

  AppBar _buildAppBar() {
    return AppBar(title: Text('My Accounts'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnedAccountsBloc, OwnedAccountsStates>(
        builder: (BuildContext context, OwnedAccountsStates state) {
          return _getStateWidget(context, state);
        }
    );
  }

  Widget _getStateWidget(BuildContext context, OwnedAccountsStates state) {
    if(state is Loading) {
      return Scaffold(appBar: _buildAppBar(), body: LinearProgressIndicator());
    } else if(state is LoadDataFail) {
      return Scaffold(appBar: _buildAppBar(), body: Center(child: Text(state.error)));
    } else {
      dynamic data = (state as LoadDataSuccess).data['ownedWallets'];
      return Scaffold(appBar: _buildAppBar(), body: _buildAccountListWidget(data));
    }
  }

  Widget _buildAccountListWidget(dynamic data) {
    List ownedAccounts = data as List;
    return ListView.separated(
      itemCount: ownedAccounts.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(ownedAccounts[index]['publicKey']),
            onTap: () {
              String publicKey = ownedAccounts[index]['publicKey'];
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
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}

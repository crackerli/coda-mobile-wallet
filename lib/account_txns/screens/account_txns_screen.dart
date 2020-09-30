import 'package:coda_wallet/account_txns/blocs/account_txns_models.dart';
import 'package:coda_wallet/account_txns/query/account_txns_query.dart';
import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_models.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/account_txns_bloc.dart';
import '../blocs/account_txns_states.dart';
import '../blocs/account_txns_events.dart';

class AccountTxnsScreen extends StatefulWidget {
  Account account;
  AccountTxnsScreen(this.account, {Key key}) : super(key: key);

  @override
  _AccountTxnsScreenState createState() => _AccountTxnsScreenState();
}

class _AccountTxnsScreenState extends State<AccountTxnsScreen> {

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> variables = Map<String, dynamic>();
    variables['publicKey'] = widget.account.publicKey;
    final _ownedAccountsBloc = BlocProvider.of<AccountTxnsBloc>(context);
    _ownedAccountsBloc.add(FetchAccountTxns(ACCOUNT_TXNS_QUERY, variables: variables));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Detail'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildAccountBody(widget.account),
          Expanded(
            child:
              BlocBuilder<AccountTxnsBloc, AccountTxnsStates>(
                builder: (BuildContext context, AccountTxnsStates state) {
                  return _buildTxnsWidget(context, state);
                }
              )
          )
        ]
      )
    );
  }

  Widget _buildTxnsWidget(BuildContext context, AccountTxnsStates state) {
    if(state is FetchAccountTxnsLoading) {
      return LinearProgressIndicator();
    }
    
    if(state is FetchAccountTxnsFail) {
      return Center(child: Text(state.error));
    }

    List<AccountTxn> data = (state as FetchAccountTxnsSuccess).data;
    return _buildTxnsListWidget(data);
  }

  Widget _buildAccountBody(Account account) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${formatAddress(account.publicKey)}"),
                Image.asset('images/lock.png')
              ],
            ),
            Text('${formatTokenNumber(account.balance)}')
          ],
        ),
      ),
    );
  }

  Widget _buildTxnsListWidget(List<AccountTxn> accountTxns) {
    return ListView.separated(
      itemCount: accountTxns.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(accountTxns[index].userCommandHash),
          onTap: null
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}

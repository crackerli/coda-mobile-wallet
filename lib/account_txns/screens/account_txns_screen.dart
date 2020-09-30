import 'package:coda_wallet/account_txns/blocs/account_txns_models.dart';
import 'package:coda_wallet/account_txns/query/account_txns_query.dart';
import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_models.dart';
import 'package:coda_wallet/types/transaction_type.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/account_txns_bloc.dart';
import '../blocs/account_txns_states.dart';
import '../blocs/account_txns_events.dart';

// ignore: must_be_immutable
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
          Container(height: 8, color: Colors.black12),
          _buildAccountBody(widget.account),
          Container(height: 8, color: Colors.black12),
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
                Text("${formatHashEllipsis(account.publicKey)}"),
                Container(width: 10),
                Image.asset('images/lock.png', width: 20, height: 20)
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
        return _buildTxnItem(accountTxns[index]);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Widget _getTxnTypeIcon(AccountTxn accountTxn) {
    if(_getTxnType(accountTxn) == TxnType.send) {
      return Image.asset('images/txsend.png', width: 24, height: 24);
    }

    if(_getTxnType(accountTxn) == TxnType.receive) {
      return Image.asset('images/txreceive.png', width: 24, height: 24);
    }

    return Container();
  }

  TxnType _getTxnType(AccountTxn accountTxn) {
    if(accountTxn.fromAccount == widget.account.publicKey) {
      return TxnType.send;
    }

    if(accountTxn.toAccount == widget.account.publicKey) {
      return TxnType.receive;
    }

    return TxnType.none;
  }

  Widget _getFormattedTxnAmount(AccountTxn accountTxn) {
    if(_getTxnType(accountTxn) == TxnType.receive) {
      return Text('+${formatTokenNumber(accountTxn.amount)}', style: TextStyle(color: Colors.lightGreen));
    }

    if(_getTxnType(accountTxn) == TxnType.send) {
      return Text('-${formatTokenNumber(accountTxn.amount)}', style: TextStyle(color: Colors.lightBlue));
    }

    return Text('${formatTokenNumber(accountTxn.amount)}', style: TextStyle(color: Colors.black54));
  }

  Widget _buildTxnItem(AccountTxn accountTxn) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 6, left: 10, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getTxnTypeIcon(accountTxn),
              Container(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${formatHashEllipsis(accountTxn.userCommandHash)}', style: TextStyle(color: Colors.black87)),
                  Container(height: 8),
                  Text('02/13/2020 16:21:46', style: TextStyle(color: Color(0xffdddddd))),
                ],
              ),
            ]
          ),
          Row(
            children: [
              Text('fee: ${formatTokenNumber(accountTxn.fee)}', style: TextStyle(color: Colors.indigoAccent)),
              Container(width: 40),
              _getFormattedTxnAmount(accountTxn)
            ],
          )
        ],
      ),
    );
  }
}

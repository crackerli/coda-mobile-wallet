import 'package:coda_wallet/account_txns/blocs/account_txns_entity.dart';
import 'package:coda_wallet/account_txns/query/account_txns_query.dart';
import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_models.dart';
import 'package:coda_wallet/types/list_operation_type.dart';
import 'package:coda_wallet/types/transaction_type.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:coda_wallet/util/navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/account_txns_bloc.dart';
import '../blocs/account_txns_states.dart';
import '../blocs/account_txns_events.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// ignore: must_be_immutable
class AccountTxnsScreen extends StatefulWidget {
  Account account;
  AccountTxnsScreen(this.account, {Key key}) : super(key: key);

  @override
  _AccountTxnsScreenState createState() => _AccountTxnsScreenState();
}

class _AccountTxnsScreenState extends State<AccountTxnsScreen> {
  ScrollController _scrollController = ScrollController();
  AccountTxnsBloc _ownedAccountsBloc;

  _refreshTxns() {
    Map<String, dynamic> variables = Map<String, dynamic>();
    variables['publicKey'] = widget.account.publicKey;
    variables['before'] = null;
    _ownedAccountsBloc.add(RefreshAccountTxns(ACCOUNT_TXNS_QUERY, variables: variables));
  }

  _loadMoreTxns(String before) {
    Map<String, dynamic> variables = Map<String, dynamic>();
    variables['publicKey'] = widget.account.publicKey;
    variables['before'] = before;
    _ownedAccountsBloc.add(MoreAccountTxns(ACCOUNT_TXNS_QUERY, variables: variables));
  }

  Future<Null> _onRefresh() async {
    if(!_ownedAccountsBloc.isTxnsLoading) {
      _refreshTxns();
      _ownedAccountsBloc.listOperation = ListOperationType.PULL_DOWN;
    }
  }

  @override
  void initState() {
    super.initState();

    _ownedAccountsBloc = BlocProvider.of<AccountTxnsBloc>(context);
    _refreshTxns();

    _scrollController.addListener(() {
      if(_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
        if(_ownedAccountsBloc.hasNextPage && !_ownedAccountsBloc.isTxnsLoading) {
          _loadMoreTxns(_ownedAccountsBloc.lastCursor);
          _ownedAccountsBloc.listOperation = ListOperationType.PULL_UP;
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
      floatingActionButton: _buildActionButton(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(height: 8, color: Colors.black12),
            Expanded(
              flex: 1,
              child: _buildAccountBody(widget.account),
            ),
            Container(height: 8, color: Colors.black12),
            Expanded(
              flex: 5,
              child:
                BlocBuilder<AccountTxnsBloc, AccountTxnsStates>(
                  builder: (BuildContext context, AccountTxnsStates state) {
                    return _buildTxnsWidget(context, state);
                  }
                )
            )
          ]
        )
      )
    );
  }

  Widget _buildActionButton() {
    return SpeedDial(
      child: Icon(Icons.add),
      children:[
        SpeedDialChild(
          child: Icon(Icons.send),
          backgroundColor: Colors.red,
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('FIRST CHILD')
        ),
        SpeedDialChild(
          child: Icon(Icons.receipt),
          backgroundColor: Colors.orange,
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => toQrAddressScreen(context, widget.account.publicKey),
        ),
      ]
    );
  }

  Widget _buildTxnsWidget(BuildContext context, AccountTxnsStates state) {
    if(state is RefreshAccountTxnsLoading) {
      return Container(
        child: Center(
          child: CircularProgressIndicator()
        )
      );
    }

    if(state is RefreshAccountTxnsFail) {
      return Center(child: Text(state.error));
    }

    if(state is MoreAccountTxnsLoading) {
      List<MergedUserCommand> data = state.data;
      return _buildTxnsListWidget(data);
    }

    if(state is RefreshAccountTxnsSuccess) {
      List<MergedUserCommand> data = state.data;
      return _buildTxnsListWidget(data);
    }

    if(state is MoreAccountTxnsSuccess) {
      List<MergedUserCommand> data = state.data;
      return _buildTxnsListWidget(data);
    }
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
                Image.asset('images/locked.png', width: 20, height: 20)
              ],
            ),
            Text('${formatTokenNumber(account.balance)}')
          ],
        ),
      ),
    );
  }

  Widget _buildTxnsListWidget(List<MergedUserCommand> accountTxns) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: accountTxns.length,
      itemBuilder: (context, index) {
        return _buildTxnItem(accountTxns[index]);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      controller: _scrollController
    );
  }

  Widget _getTxnTypeIcon(MergedUserCommand userCommand) {
    if(_getTxnType(userCommand) == TxnType.SEND) {
      return Image.asset('images/txsend.png', width: 24, height: 24);
    }

    if(_getTxnType(userCommand) == TxnType.RECEIVE ||
        _getTxnType(userCommand) == TxnType.MINTED) {
      return Image.asset('images/txreceive.png', width: 24, height: 24);
    }

    return Container();
  }

  TxnType _getTxnType(MergedUserCommand userCommand) {
    if(userCommand.isMinted) {
      return TxnType.MINTED;
    }

    if(userCommand.from == widget.account.publicKey) {
      return TxnType.SEND;
    }

    if(userCommand.to == widget.account.publicKey) {
      return TxnType.RECEIVE;
    }

    return TxnType.NONE;
  }

  Widget _getDateTimeText(MergedUserCommand userCommand) {
    if(null == userCommand) {
      return Container();
    }

    if(userCommand.isPooled) {
      return Text('Pending', style: TextStyle(color: Color(0xffdddddd)));
    }
    return Text('${formatDateTime(userCommand.dateTime)}', style: TextStyle(color: Color(0xffeeeeee)));
  }

  Widget _getFormattedTxnAmount(MergedUserCommand userCommand) {
    if(_getTxnType(userCommand) == TxnType.MINTED) {
      return Text('+${formatTokenNumber(userCommand.coinbase)}',
        style: TextStyle(color: Colors.lightGreen));
    }

    if(_getTxnType(userCommand) == TxnType.RECEIVE) {
      return Text('+${formatTokenNumber(userCommand.amount)}',
        style: TextStyle(color: Colors.lightGreen));
    }

    if(_getTxnType(userCommand) == TxnType.SEND) {
      return Text('-${formatTokenNumber(userCommand.amount)}',
        style: TextStyle(color: Colors.lightBlue));
    }

    return Text('${formatTokenNumber(userCommand.amount)}',
      style: TextStyle(color: Colors.black54));
  }
  
  Widget _getCommandHashText(MergedUserCommand userCommand) {
    if(_getTxnType(userCommand) == TxnType.MINTED) {
      return Text('Minted', style: TextStyle(color: Colors.black87));
    }
    return Text('${formatHashEllipsis(userCommand.hash)}',
      style: TextStyle(color: Colors.black87));
  }
  
  Widget _getTxnFeeText(MergedUserCommand userCommand) {
    if(_getTxnType(userCommand) == TxnType.MINTED) {
      return Container();
    }
    return Text('fee: ${formatTokenNumber(userCommand.fee)}',
      style: TextStyle(color: Colors.indigoAccent));
  }

  Widget _buildTxnItem(MergedUserCommand userCommand) {
    if(userCommand.coinbase == 'load_more') {
      return Container(
        child: Center(
          child: SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(Colors.blue),
              value: .7,
            )
          )
        )
      );
    }
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
              _getTxnTypeIcon(userCommand),
              Container(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getCommandHashText(userCommand),
                  Container(height: 8),
                  _getDateTimeText(userCommand)
                ],
              ),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _getTxnFeeText(userCommand),
              Container(width: 20),
              _getFormattedTxnAmount(userCommand)
            ],
          )
        ],
      ),
    );
  }
}

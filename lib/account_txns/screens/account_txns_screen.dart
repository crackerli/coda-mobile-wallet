import 'package:coda_wallet/account_txns/blocs/account_txns_entity.dart';
import 'package:coda_wallet/account_txns/query/account_txns_query.dart';
import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/owned_wallets/blocs/owned_accounts_entity.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'accounts_txns_screen_dialog.dart';

// ignore: must_be_immutable
class AccountTxnsScreen extends StatefulWidget {
  Account account;
  AccountTxnsScreen(this.account, {Key key}) : super(key: key);

  @override
  _AccountTxnsScreenState createState() => _AccountTxnsScreenState();
}

class _AccountTxnsScreenState extends State<AccountTxnsScreen> {
  ScrollController _scrollController = ScrollController();
  AccountTxnsBloc _accountTxnsBloc;

  _refreshTxns() {
    Map<String, dynamic> variables = Map<String, dynamic>();
    variables['publicKey'] = widget.account.publicKey;
    variables['before'] = null;
    _accountTxnsBloc.add(RefreshAccountTxns(ACCOUNT_TXNS_QUERY, variables: variables));
  }

  _loadMoreTxns(String before) {
    Map<String, dynamic> variables = Map<String, dynamic>();
    variables['publicKey'] = widget.account.publicKey;
    variables['before'] = before;
    _accountTxnsBloc.add(MoreAccountTxns(ACCOUNT_TXNS_QUERY, variables: variables));
  }

  Future<Null> _onRefresh() async {
    if(!_accountTxnsBloc.isTxnsLoading) {
      _refreshTxns();
      _accountTxnsBloc.listOperation = ListOperationType.PULL_DOWN;
    }
  }

  @override
  void initState() {
    super.initState();

    _accountTxnsBloc = BlocProvider.of<AccountTxnsBloc>(context);
    _refreshTxns();

    _scrollController.addListener(() {
      if(_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
        if(_accountTxnsBloc.hasNextPage && !_accountTxnsBloc.isTxnsLoading) {
          _loadMoreTxns(_accountTxnsBloc.lastCursor);
          _accountTxnsBloc.listOperation = ListOperationType.PULL_UP;
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _accountTxnsBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(1080, 2316), allowFontScaling: false);
    return Scaffold(
      appBar: _buildAccountTxnsAppBar(),
      floatingActionButton: _buildActionButton(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocBuilder<AccountTxnsBloc, AccountTxnsStates>(
          builder: (BuildContext context, AccountTxnsStates state) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 8, color: Colors.black12),
              Expanded(
                flex: 1,
                child: _buildAccountBody(context, state),
              ),
              Container(height: 8, color: Colors.black12),
              Expanded(
                flex: 4,
                child: _buildTxnsWidget(context, state)
              )
            ]
          );
        })
      )
    );
  }

  Widget _buildAccountTxnsAppBar() {
    return PreferredSize(
      child: AppBar(
        title: Text('Account Detail',
          style: TextStyle(fontSize: APPBAR_TITLE_FONT_SIZE.sp, color: Color(0xff0b0f12))),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          tooltip: 'Navigation',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      preferredSize: Size.fromHeight(APPBAR_HEIGHT.h)
    );
  }

  Widget _buildActionButton() {
    return SpeedDial(
      child: Icon(Icons.add),
      children:[
        SpeedDialChild(
          child: Icon(Icons.send),
          backgroundColor: Colors.red,
          label: 'Send',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => toSendTokenScreen(context,
            _accountTxnsBloc.accountStatus.publicKey,
            _accountTxnsBloc.accountStatus.balance,
            _accountTxnsBloc.accountStatus.locked)
        ),
        SpeedDialChild(
          label: 'Receive',
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
      AccountDetail accountDetail = state.data;
      if(null == accountDetail ||
         null == accountDetail.mergedUserCommands ||
         0 == accountDetail.mergedUserCommands.length) {
        return Container(
          child: Center(
            child: CircularProgressIndicator()
          )
        );
      } else {
        return _buildTxnsListWidget(accountDetail.mergedUserCommands);
      }
    }

    if(state is RefreshAccountTxnsFail) {
      return Center(child: Text(state.error));
    }

    if(state is MoreAccountTxnsLoading) {
      AccountDetail accountDetail = state.data;
      return _buildTxnsListWidget(accountDetail.mergedUserCommands);
    }

    if(state is RefreshAccountTxnsSuccess) {
      AccountDetail accountDetail = state.data;
      if(null == accountDetail ||
         null == accountDetail.mergedUserCommands ||
         0 == accountDetail.mergedUserCommands.length) {
        return Center(child: Text('No Transactions', style: TextStyle(color: Color(0xffbbbbbb)),));
      }
      return _buildTxnsListWidget(accountDetail.mergedUserCommands);
    }

    if(state is MoreAccountTxnsSuccess) {
      AccountDetail accountDetail = state.data;
      return _buildTxnsListWidget(accountDetail.mergedUserCommands);
    }

    if(state is AccountNameChanged) {
      AccountDetail accountDetail = state.data;
      return _buildTxnsListWidget(accountDetail.mergedUserCommands);
    }

    return Container();
  }

  _editAccountName(BuildContext context) async {
    String name = await showEditAccountNameDialog(context);
    if(null == name || name.isEmpty) {
      return;
    }

    globalPreferences.setString(_accountTxnsBloc.accountStatus.publicKey, name);
    _accountTxnsBloc.accountStatus.accountName = name;
    _accountTxnsBloc.add(EditAccountName());
  }

  Widget _buildAccountBody(BuildContext context, AccountTxnsStates state) {
    AccountDetail accountDetail;
    String publicKey;
    String balance;
    bool locked;

    if(state is RefreshAccountTxnsLoading) {
      accountDetail = state.data;
    }

    if(state is MoreAccountTxnsLoading) {
      accountDetail = state.data;
    }

    if(state is RefreshAccountTxnsSuccess) {
      accountDetail = state.data;
    }

    if(state is MoreAccountTxnsSuccess) {
      accountDetail = state.data;
    }

    if(null != accountDetail) {
      publicKey = null == accountDetail.accountStatus.publicKey ? widget.account.publicKey : accountDetail.accountStatus.publicKey;
      balance = null == accountDetail.accountStatus.balance ? widget.account.balance : accountDetail.accountStatus.balance;
      locked = null == accountDetail.accountStatus.locked ? widget.account.locked : accountDetail.accountStatus.locked;
    } else {
      publicKey = widget.account.publicKey;
      balance = widget.account.balance;
      locked = widget.account.locked;
    }

    return Padding(
      padding: EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildAccountName(),
                Container(width: 6),
                GestureDetector(
                  child: Image.asset('images/edit_name.png', width: 20, height: 20,),
                  onTap: () => _editAccountName(context)
                ),
              ]
            ),
            Container(height: 6),
            Text(publicKey, softWrap: true, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 3,),
            Container(height: 6),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Balance: ${formatTokenNumber(balance)}'),
                Image.asset(locked ? 'images/locked_black.png' : 'images/unlocked_green.png', width: 20, height: 20)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountName() {
    String name = globalPreferences.getString(widget.account.publicKey);
    if(null == name || name.isEmpty) {
      name = 'Default Name';
    }
    return Text(name, style: TextStyle(fontWeight: FontWeight.bold));
  }

  Widget _buildTxnsListWidget(List<MergedUserCommand> accountTxns) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: accountTxns.length,
      itemBuilder: (context, index) {
        return _buildTxnItem(accountTxns[index]);
      },
      separatorBuilder: (context, index) {
        return Divider(thickness: 4,);
      },
      controller: _scrollController
    );
  }

  Widget _getTxnTypeIcon(MergedUserCommand userCommand) {
    if(_getTxnType(userCommand) == TxnType.SEND) {
      return Image.asset('images/txsend.png', width: 65.w, height: 65.w);
    }

    if(_getTxnType(userCommand) == TxnType.RECEIVE ||
        _getTxnType(userCommand) == TxnType.MINTED) {
      return Image.asset('images/txreceive.png', width: 65.w, height: 65.w);
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
      return Text('Pending', style: TextStyle(color: Color.fromARGB(0xff, 199, 199, 199), fontSize: 40.sp));
    }
    return Text('${formatDateTime(userCommand.dateTime)}',
      style: TextStyle(color: Color.fromARGB(0xff, 199, 199, 199), fontSize: 40.sp));
  }

  Widget _getFormattedTxnAmount(MergedUserCommand userCommand) {
    if(_getTxnType(userCommand) == TxnType.MINTED) {
      return Text('+${formatTokenNumber(userCommand.coinbase)}', textAlign: TextAlign.right,
        style: TextStyle(color: Color.fromARGB(0xff, 34, 180, 161), fontSize: 40.sp));
    }

    if(_getTxnType(userCommand) == TxnType.RECEIVE) {
      return Text('+${formatTokenNumber(userCommand.amount)}',textAlign: TextAlign.right,
        style: TextStyle(color: Color.fromARGB(0xff, 34, 180, 161), fontSize: 40.sp));
    }

    if(_getTxnType(userCommand) == TxnType.SEND) {
      return Text('-${formatTokenNumber(userCommand.amount)}',textAlign: TextAlign.right,
        style: TextStyle(color: Color.fromARGB(0xff, 39, 139, 191), fontSize: 40.sp));
    }

    return Text('${formatTokenNumber(userCommand.amount)}',textAlign: TextAlign.right,
      style: TextStyle(color: Colors.black54, fontSize: 40.sp));
  }
  
  Widget _getCommandHashText(MergedUserCommand userCommand) {
    if(_getTxnType(userCommand) == TxnType.MINTED) {
      return Text('Minted', style: TextStyle(color: Colors.green, fontSize: 40.sp));
    }
    return Text('${formatHashEllipsis(userCommand.hash)}',
      style: TextStyle(color: Color.fromARGB(0xff, 129, 134, 137), fontSize: 40.sp));
  }
  
  Widget _getTxnFeeText(MergedUserCommand userCommand) {
    if(_getTxnType(userCommand) == TxnType.MINTED) {
      return Container();
    }
    return Text('fee: ${formatTokenNumber(userCommand.fee)}',
      style: TextStyle(color: Colors.grey, fontSize: 36.sp), textAlign: TextAlign.right,);
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
    return Padding(
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getFormattedTxnAmount(userCommand),
              Container(height: 2),
              _getTxnFeeText(userCommand)
            ],
          )
        ],
      ),
    );
  }
}

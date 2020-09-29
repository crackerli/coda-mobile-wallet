import 'package:coda_wallet/account_txns/blocs/account_txns_models.dart';
import 'package:coda_wallet/account_txns/query/account_txns_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/account_txns_bloc.dart';
import '../blocs/account_txns_states.dart';
import '../blocs/account_txns_events.dart';

class AccountTxnsScreen extends StatefulWidget {
  String publicKey;
  AccountTxnsScreen(this.publicKey, {Key key}) : super(key: key);

  @override
  _AccountTxnsScreenState createState() => _AccountTxnsScreenState();
}

class _AccountTxnsScreenState extends State<AccountTxnsScreen> {

  @override
  void initState() {
    Map<String, dynamic> variables = Map<String, dynamic>();
    variables['publicKey'] = widget.publicKey;
    final _ownedAccountsBloc = BlocProvider.of<AccountTxnsBloc>(context);
    _ownedAccountsBloc.add(FetchAccountTxns(ACCOUNT_TXNS_QUERY, variables: variables));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  AppBar _buildAppBar() {
    return AppBar(title: Text('Coda Wallet'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountTxnsBloc, AccountTxnsStates>(
      builder: (BuildContext context, AccountTxnsStates state) {
        return _getStateWidget(context, state);
      }
    );
  }

  Widget _getStateWidget(BuildContext context, AccountTxnsStates state) {
    if(state is FetchAccountTxnsLoading) {
      return Scaffold(appBar: _buildAppBar(), body: LinearProgressIndicator());
    } else if(state is FetchAccountTxnsFail) {
      return Scaffold(appBar: _buildAppBar(), body: Center(child: Text(state.error)));
    } else {
      List<AccountTxn> data = (state as FetchAccountTxnsSuccess).data;
      return Scaffold(appBar: _buildAppBar(), body: _buildTxListWidget(data));
    }
  }

  // String getUserCommandsIdFromTX(List userCommands) {
  //   if(null == userCommands) {
  //     return '';
  //   }
  //
  //   if(userCommands.length == 0) {
  //     return '';
  //   }
  //
  //   return userCommands[0]['id'];
  // }

  // removeNullBlocks(List txns) {
  //   txns.removeWhere((element) {
  //     List userCmds = element['transactions']['userCommands'] as List;
  //     if(userCmds.length == 0) {
  //       return true;
  //     }
  //     return false;
  //   });
  // }

  Widget _buildTxListWidget(List<AccountTxn> accountTxns) {
//    removeNullBlocks(txns);
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

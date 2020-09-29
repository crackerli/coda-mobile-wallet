import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/account_txns_bloc.dart';
import '../blocs/account_txns_states.dart';
import '../blocs/account_txns_events.dart';
import '../query/account_txns_query.dart';

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
    _ownedAccountsBloc.add(FetchAccountTxnsData(ACCOUNT_TXNS_QUERY, variables: variables));
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
    if(state is Loading) {
      return Scaffold(appBar: _buildAppBar(), body: LinearProgressIndicator());
    } else if(state is LoadDataFail) {
      return Scaffold(appBar: _buildAppBar(), body: Center(child: Text(state.error)));
    } else {
      dynamic data = (state as LoadDataSuccess).data['blocks'];
      return Scaffold(appBar: _buildAppBar(), body: _buildTxListWidget(data));
    }
  }

  String getUserCommandsIdFromTX(List userCommands) {
    if(null == userCommands) {
      return '';
    }

    if(userCommands.length == 0) {
      return '';
    }

    return userCommands[0]['id'];
  }

  removeNullBlocks(List txns) {
    txns.removeWhere((element) {
      List userCmds = element['transactions']['userCommands'] as List;
      if(userCmds.length == 0) {
        return true;
      }
      return false;
    });
  }

  Widget _buildTxListWidget(dynamic data) {
    List txns = data['nodes'] as List;

    removeNullBlocks(txns);
    return ListView.separated(
      itemCount: txns.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(getUserCommandsIdFromTX(txns[index]['transactions']['userCommands'] as List)),
          onTap: null
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}

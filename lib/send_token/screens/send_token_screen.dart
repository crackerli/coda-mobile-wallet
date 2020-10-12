import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendTokenScreen extends StatefulWidget {
  String publicKey;
  String balance;
  bool locked;

  SendTokenScreen(
    String publicKey,
    String balance,
    bool locked,
    {Key key}) : super(key: key);

  @override
  _SendTokenScreenState
    createState() => _SendTokenScreenState();
}

class _SendTokenScreenState extends State<SendTokenScreen> {

  @override
  void initState() {
    // final _ownedAccountsBloc = BlocProvider.of<OwnedAccountsBloc>(context);
    // _ownedAccountsBloc.add(FetchOwnedAccounts(OWNED_ACCOUNTS_QUERY));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Send Mina'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container()
    );
  }
}
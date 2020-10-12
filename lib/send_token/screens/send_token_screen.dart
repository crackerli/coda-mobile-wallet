import 'package:coda_wallet/util/navigations.dart';
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
          actions: [
            IconButton(
              icon: Image.asset('images/qr_scan2.png', width: 24, height: 24),
              tooltip: 'Scan',
              iconSize: 24,
              onPressed: () => toQrScanScreen(context),
            ),
          ],
        ),
        body: Container()
    );
  }
}
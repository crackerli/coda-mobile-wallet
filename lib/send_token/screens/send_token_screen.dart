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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          )
        ]
      ),
      body: _buildSendTokenBody()
    );
  }

  Widget _buildSendTokenBody() {
    return Container(
      color: Color(0xffeeeeee),
      padding: EdgeInsets.only(left: 6, right: 6, top: 16),
      child:
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 6),
            child: Text('Receiver address'),
          ),
          Container(height: 10),
          _buildReceiverTextField(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('Balance'),
              Text('12 Mina'),
            ]
          ),
          Container(height: 10,),
          // _buildSendActionTextField(),
          _buildFeeCostTextField(),
          Container(
            child: Center(
              child: RaisedButton(
                onPressed: () {},
                color: Colors.red[300],
                child: Text("RaisedButton", style: TextStyle(color: Colors.white))
              )
            )
          )
        ]
      )
    );
  }

  Widget _buildReceiverTextField() {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 10,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 200.0,
                  minHeight: 24.0,
                ),
                child: TextField(
    //              controller: _remarkTextController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  autofocus: true,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Mina address',
                  ),
                ),
              )
            ),
            Expanded(
              flex: 1,
              child: Image.asset('images/locked.png', width: 24, height: 24)
            )
          ]
        )
      )
    );
  }

  Widget _buildSendActionTextField() {
    return Container();
  }

  Widget _buildFeeCostTextField() {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('Fee'),
            Expanded(
              flex: 10,
              child: Text('0.11111111111111111111111', textAlign: TextAlign.right)
            ),
            Container(width: 10,),
            Text('Edit')
          ]
        )
      )
    );
  }
}
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
          Padding(
            padding: EdgeInsets.only(left: 6, right: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Balance'),
                Text('12 Mina'),
              ]
            ),
          ),
          Container(height: 10,),
          _buildSendActionTextField(),
          _buildFeeCostTextField(),
          Container(height: 160),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      onPressed: () {},
                      color: Colors.blueAccent,
                      child: Text("Send", style: TextStyle(color: Colors.white))
                    )
                  )
                ],
            ))
          )
        ]
      )
    );
  }

  Widget _buildReceiverTextField() {
    return Card(
      color: Colors.white,
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
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  autofocus: true,
                  decoration: InputDecoration.collapsed(hintText: 'Mina address')
                ),
              )
            ),
            Expanded(
              flex: 1,
              child: Image.asset('images/contact_address.png', width: 24, height: 24)
            )
          ]
        )
      )
    );
  }

  Widget _buildSendActionTextField() {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
        child: Column(
          children: [
            TextField(
              style: TextStyle(fontSize: 48),
              decoration: InputDecoration.collapsed(hintText: '0')
            ),
            Container(height: 1.5, color: Color(0xffeeeeee)),
            TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              autofocus: false,
              decoration: InputDecoration.collapsed(hintText: 'Memo'),
            )
          ]
        )
      )
    );
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
              child: Text('0.1', textAlign: TextAlign.right)
            ),
            Container(width: 10),
            Text('Edit')
          ]
        )
      )
    );
  }
}
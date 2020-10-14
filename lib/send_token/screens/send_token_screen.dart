import 'package:coda_wallet/send_token/blocs/send_token_bloc.dart';
import 'package:coda_wallet/send_token/blocs/send_token_events.dart';
import 'package:coda_wallet/send_token/blocs/send_token_states.dart';
import 'package:coda_wallet/send_token/mutation/send_token_mutation.dart';
import 'package:coda_wallet/types/send_token_action_status.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:coda_wallet/util/navigations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class SendTokenScreen extends StatefulWidget {
  String publicKey;
  String balance;
  bool locked;

  SendTokenScreen(
    String publicKey,
    String balance,
    bool locked,
    {Key key}) : super(key: key) {
    this.publicKey = publicKey;
    this.balance = balance;
    this.locked = locked;
  }

  @override
  _SendTokenScreenState
    createState() => _SendTokenScreenState();
}

class _SendTokenScreenState extends State<SendTokenScreen> {

  TextEditingController _feeController     = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _amountController  = TextEditingController();
  TextEditingController _memoController    = TextEditingController();
  dynamic _qrResult;
  SendTokenBloc _sendTokenBloc;

  @override
  void initState() {
    super.initState();
    _sendTokenBloc = BlocProvider.of<SendTokenBloc>(context);
    _sendTokenBloc.sender = widget.publicKey;
  }

  @override
  void dispose() {
    _sendTokenBloc = null;

    _memoController.dispose();
    _feeController.dispose();
    _addressController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  _fillQrAddress() async {
    _qrResult =  await toQrScanScreen(context);
    _addressController.text = '$_qrResult';
    _sendTokenBloc.receiver = '$_qrResult';
  }

  _sendPayment() {
    _sendTokenBloc.amount = _amountController.text;
    Map<String, dynamic> variables = Map<String, dynamic>();
    variables['from'] = _sendTokenBloc.sendTokenEntity.sender;
    variables['to'] = _sendTokenBloc.sendTokenEntity.receiver;
    variables['amount'] = getNanoMina(_sendTokenBloc.sendTokenEntity.amount);
    variables['memo'] = _sendTokenBloc.sendTokenEntity.memo;
    variables['fee'] = getNanoMina(_sendTokenBloc.sendTokenEntity.fee);

    _sendTokenBloc.add(SendPayment(SEND_PAYMENT_MUTATION, variables: variables));
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
            icon: Image.asset('images/qr_scan.png', width: 24, height: 24),
            tooltip: 'Scan',
            iconSize: 24,
            onPressed: _fillQrAddress,
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
                Expanded(
                  flex: 1,
                  child: Text('${formatTokenNumber(widget.balance)} Mina',
                    textAlign: TextAlign.right, style: TextStyle(color: Colors.blueAccent))
                )
              ]
            ),
          ),
          Container(height: 10,),
          _buildSendContentTextField(),
          _buildFeeCostTextField(),
          _buildLockStatus(),
          Container(height: 40),
          BlocBuilder<SendTokenBloc, SendTokenStates>(
            builder:(BuildContext context, SendTokenStates state) {
              return  _buildSendAction(context, state);
            }
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
                  controller: _addressController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  autofocus: false,
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

  Widget _buildSendContentTextField() {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              child: TextField(
                maxLines: 1,
                textAlign: TextAlign.end,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                autofocus: false,
                decoration: InputDecoration.collapsed(hintText: '0.1'),
              )
            ),
            Container(width: 10),
            Text('Mina', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))
          ]
        )
      )
    );
  }

  Widget _buildLockStatus() {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
            children: [
              Text('LockStatus'),
              Image.asset('images/unlocked_green.png', width: 24, height: 24)
            ]
          )
        )
    );
  }
  
  Widget _buildSendAction(BuildContext context, SendTokenStates state) {
    Color sendTextColor;
    Color sendButtonColor;
    Widget sendAction;

    // if(status == SendTokenActionStatus.contentInvalid) {
    //   sendTextColor = Colors.black54;
    //   sendButtonColor = Colors.grey;
    //   sendAction = Text("Send", style: TextStyle(color: sendTextColor));
    // } else if(status == SendTokenActionStatus.tokenSending) {
    //   sendTextColor = Colors.black54;
    //   sendButtonColor = Colors.blueAccent;
    //   sendAction = SizedBox(child: CircularProgressIndicator(
    //     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    //   ), height: 26.0, width: 26.0);
    // } else {
    //   sendTextColor = Colors.white;
    //   sendButtonColor = Colors.blueAccent;
    //   sendAction = Text("Send", style: TextStyle(color: sendTextColor));
    // }

    if(state is SendPaymentLoading) {
      sendTextColor = Colors.black54;
      sendButtonColor = Colors.blueAccent;
      sendAction = SizedBox(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ), height: 26.0, width: 26.0);
    } else if(state is SendPaymentSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final snackBar = SnackBar(content: Text('Mina sent'));
        Scaffold.of(context).showSnackBar(snackBar);
      });
      sendTextColor = Colors.white;
      sendButtonColor = Colors.blueAccent;
      sendAction = Text("Send", style: TextStyle(color: sendTextColor));
    } else {
      sendTextColor = Colors.white;
      sendButtonColor = Colors.blueAccent;
      sendAction = Text("Send", style: TextStyle(color: sendTextColor));
    }

    return Container(
      height: 50,
      child: SizedBox.expand(
        child: RaisedButton(
          padding: EdgeInsets.only(top: 12, bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
          onPressed: _sendPayment,
          color: sendButtonColor,
          child: sendAction
        )
      )
    );
  }
}
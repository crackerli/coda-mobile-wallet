import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/send_token/blocs/send_token_bloc.dart';
import 'package:coda_wallet/send_token/blocs/send_token_events.dart';
import 'package:coda_wallet/send_token/blocs/send_token_states.dart';
import 'package:coda_wallet/send_token/mutation/send_token_mutation.dart';
import 'package:coda_wallet/send_token/screens/send_token_dialog.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:coda_wallet/util/input_formatters.dart';
import 'package:coda_wallet/util/navigations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

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
  final _focusNodeAmount   = FocusNode();
  final _focusNodeReceiver = FocusNode();
  final _focusNodeMeme     = FocusNode();
  final _focusNodeFee      = FocusNode();

  @override
  void initState() {
    super.initState();
    _sendTokenBloc = BlocProvider.of<SendTokenBloc>(context);
    _sendTokenBloc.sender = widget.publicKey;
    _sendTokenBloc.isLocked = widget.locked;
    _sendTokenBloc.balance = widget.balance;
    _feeController.text = _sendTokenBloc.fee;
    _focusNodeAmount.addListener(() {
      if(_focusNodeAmount.hasFocus) {

      } else {
        if(!checkSendAmountValidation(_amountController.text)) {
          if(_focusNodeAmount.canRequestFocus) {
            _focusNodeAmount.requestFocus();
          }
        }
      }
    });

    _focusNodeFee.addListener(() {
      if(_focusNodeFee.hasFocus) {

      } else {
        if(!checkFeeValidation(_feeController.text)) {
          if(_focusNodeFee.canRequestFocus) {
            _focusNodeFee.requestFocus();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _sendTokenBloc = null;

    _memoController?.dispose();
    _feeController?.dispose();
    _addressController?.dispose();
    _amountController?.dispose();
    _focusNodeAmount?.dispose();
    _focusNodeFee?.dispose();
    _focusNodeMeme?.dispose();
    _focusNodeReceiver?.dispose();

    super.dispose();
  }

  _fillQrAddress() async {
    _qrResult = await toQrScanScreen(context);
    _addressController.text = '$_qrResult';
    _sendTokenBloc.receiver = '$_qrResult';
    _sendTokenBloc.add(ValidateInput());
  }

  _sendPayment() {
    _sendTokenBloc.sendAmount = _amountController.text;
    _sendTokenBloc.memo = _memoController.text;
    _sendTokenBloc.fee = _feeController.text;
    Map<String, dynamic> variables = Map<String, dynamic>();
    variables['from'] = _sendTokenBloc.sender;
    variables['to'] = _sendTokenBloc.receiver;
    variables['amount'] = getNanoMina(_sendTokenBloc.sendAmount);
    variables['memo'] = _sendTokenBloc.memo;
    variables['fee'] = getNanoMina(_sendTokenBloc.fee);

    _sendTokenBloc.add(SendPayment(SEND_PAYMENT_MUTATION, variables: variables));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(1080, 2316), allowFontScaling: false);
    return Scaffold(
      appBar: _buildSendTokenAppBar(),
      body: KeyboardActions(
        tapOutsideToDismiss: true,
        autoScroll: true,
        config: KeyboardActionsConfig(
          keyboardSeparatorColor: Colors.grey,
          nextFocus: false,
          actions: [
            KeyboardActionsItem(
              focusNode: _focusNodeReceiver,
            ),
            KeyboardActionsItem(
              focusNode: _focusNodeAmount,
            ),
            KeyboardActionsItem(
              focusNode: _focusNodeMeme,
            ),
            KeyboardActionsItem(
              focusNode: _focusNodeFee,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: BlocBuilder<SendTokenBloc, SendTokenStates>(
              builder:(BuildContext context, SendTokenStates state) {
                return _buildSendTokenBody(context, state);
              }
          )
        )
      )
    );
  }

  Widget _buildSendTokenAppBar() {
    return PreferredSize(
      child: AppBar(
        title: Text('Send Mina',
          style: TextStyle(fontSize: APPBAR_TITLE_FONT_SIZE.sp, color: Color(0xff0b0f12))),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          tooltip: 'Navigation',
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Image.asset('images/qr_scan.png', width: 100.w, height: 100.w),
            tooltip: 'QrCode',
            iconSize: 24,
            onPressed: _fillQrAddress,
          )
        ]
      ),
      preferredSize: Size.fromHeight(APPBAR_HEIGHT.h));
  }

  Widget _buildSendTokenBody(BuildContext context, SendTokenStates state) {
    return Container(
      color: Color(0xfff7fbfe),
      padding: EdgeInsets.only(left: 32.w, right: 32.w, top: 60.h),
      child:
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReceiverLabel(),
          Container(height: 34.h),
          _buildReceiverTextField(),
          Container(height: 32.h),
          _buildSendContentLabel(),
          Container(height: 10.h),
          _buildSendContentTextField(),
          Container(height: 10.h),
          _buildFeeCostTextField(),
          Container(height: 10.h),
          _buildLockStatus(context, state),
          //Expanded(flex: 1,
          Container(
            height: 360.h,
            child: _buildSendAction(context, state)
          )
        ]
      )
    );
  }

  Widget _buildReceiverLabel() {
    return Padding(
      padding: EdgeInsets.only(left: 13.w),
      child: Text('Receiver Address',
        style: TextStyle(fontSize: 44.sp, color: Color.fromARGB(0xff, 65, 69, 72)))
    );
  }

  Widget _buildReceiverTextField() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 44.w, right: 44.w, top: 44.h, bottom: 44.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 10,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 300.h,
                  minHeight: 37.h,
                ),
                child: TextField(
                  focusNode: _focusNodeReceiver,
                  controller: _addressController,
                  onChanged: (text) {
                    _sendTokenBloc.receiver = text;
                    _sendTokenBloc.add(ValidateInput());
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  autofocus: false,
                  decoration: InputDecoration.collapsed(hintText: 'Mina address')
                ),
              )
            ),
            Expanded(
              flex: 1,
              child: Image.asset('images/contact_address.png', width: 60.w, height: 60.w)
            )
          ]
        )
      )
    );
  }

  Widget _buildSendContentLabel() {
    return Padding(
      padding: EdgeInsets.only(left: 13.w, right: 13.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('Balance', style: TextStyle(fontSize: 44.sp, color: Color.fromARGB(0xff, 90, 94, 97)),),
          Expanded(
            flex: 1,
            child: Text(
              '${formatTokenNumber(_sendTokenBloc.balance)} Mina',
              textAlign: TextAlign.right,
              style: TextStyle(color: Color.fromARGB(0xff, 151, 154, 159),
              fontSize: 44.sp))
          )
        ]
      )
    );
  }

  Widget _buildSendContentTextField() {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 44.w, right: 44.w, top: 44.h, bottom: 44.h),
        child: Column(
          children: [
            TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
              ],
              focusNode: _focusNodeAmount,
              maxLines: 1,
              controller: _amountController,
              onChanged: (text) {
                _sendTokenBloc.sendAmount = text;
                _sendTokenBloc.add(ValidateInput());
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(fontSize: 120.sp),
              decoration: InputDecoration.collapsed(hintText: '0')
            ),
            Container(height: 6.h, color: Color(0xffeeeeee)),
            Container(height: 24.h,),
            TextField(
              focusNode: _focusNodeMeme,
              controller: _memoController,
              onChanged: (text) {
                _sendTokenBloc.memo = text;
                _sendTokenBloc.add(ValidateInput());
              },
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
      child: Padding(
        padding: EdgeInsets.only(left: 44.w, right: 44.w, top: 44.h, bottom: 44.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('Fee', style: TextStyle(fontSize: 41.sp, color: Color.fromARGB(0xff, 70, 70, 70))),
            Container(width: 4),
            Text('Min allowed: 0.001', style: TextStyle(fontSize: 34.sp, color: Colors.red)),
            Expanded(
              flex: 10,
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                ],
                focusNode: _focusNodeFee,
                controller: _feeController,
                onChanged: (text) {
                  _sendTokenBloc.fee = text;
                  _sendTokenBloc.add(ValidateInput());
                },
                maxLines: 1,
                textAlign: TextAlign.end,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                autofocus: false,
                decoration: InputDecoration.collapsed(hintText: '${_sendTokenBloc.fee}'),
              )
            ),
            Container(width: 20.w),
            Text('Mina', style: TextStyle(color: Color.fromARGB(0xff, 152, 152, 152)))
          ]
        )
      )
    );
  }

  Widget _buildLockStatus(BuildContext context, SendTokenStates state) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 44.w, right: 44.w, top: 44.h, bottom: 44.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('LockStatus', style: TextStyle(fontSize: 41.sp, color: Color.fromARGB(0xff, 70, 70, 70))),
            _buildLockActionStatus(context, state)
          ]
        )
      )
    );
  }

  Widget _buildLockActionStatus(BuildContext context, SendTokenStates state) {
    if(state is ToggleLockStatusFail) {
      String toggleLockFail;
      if(_sendTokenBloc.isLocked) {
        toggleLockFail = 'Unlock failed';
      } else {
        toggleLockFail = 'Lock failed';
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final snackBar = SnackBar(content: Text(toggleLockFail));
        Scaffold.of(context).showSnackBar(snackBar);
      });
    }

    return GestureDetector(
      child: _sendTokenBloc.isLocked ?
        Image.asset('images/locked_black.png', width: 60.w, height: 60.w) :
        Image.asset('images/unlocked_green.png', width: 60.w, height: 60.w),
      onTap: () { _clickLock(context, _sendTokenBloc.sender); }
    );
  }

  _clickLock(BuildContext context, String publicKey) {
    if(null == publicKey) {
      return;
    }

    if(_sendTokenBloc.isLocked) {
      showUnlockAccountDialog(context, _sendTokenBloc.sender);
      return;
    }

    if(!_sendTokenBloc.isLocked) {
      showLockAccountDialog(context, _sendTokenBloc.sender);
    }
  }
  
  Widget _buildSendAction(BuildContext context, SendTokenStates state) {
    Widget sendAction;

    if(state is SendPaymentLoading) {
      sendAction = SizedBox(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        height: 68.h,
        width: 68.h
      );
      _sendTokenBloc.sendEnabled = false;
    } else if(state is SendPaymentSuccess) {
      final fee = _sendTokenBloc.fee;
      final amount = _sendTokenBloc.sendAmount;
      final receiver = _sendTokenBloc.receiver;
      final memo = _sendTokenBloc.memo;
      _feeController.text = '0.1';
      _addressController.clear();
      _memoController.clear();
      _amountController.clear();
      _sendTokenBloc.isSending = false;
      _sendTokenBloc.receiver = '';
      _sendTokenBloc.memo = '';
      _sendTokenBloc.sendAmount = '';
      _sendTokenBloc.fee = '0.1';
      sendAction = Text("Send", style: TextStyle(color: Colors.white, fontSize: 44.sp));
      _sendTokenBloc.sendEnabled = false;
      _sendTokenBloc.add(ValidateInput());

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSendSuccessDialog(context, receiver, amount, memo, fee);
      });
    } else if(state is SendPaymentFail) {
      dynamic error = state.error;
      _sendTokenBloc.add(ValidateInput());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSendFailDialog(context, error.toString());
      });
      sendAction = Text("Send", style: TextStyle(color: Colors.white, fontSize: 44.sp));
    } else {
      sendAction = Text("Send", style: TextStyle(color: Colors.white, fontSize: 44.sp));
    }

    return Container(
      padding: EdgeInsets.only(left: 32.w, right: 32.w, bottom: 64.h),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child:
            Container(),
          ),
          Container(
            height: 160.h,
            child: SizedBox.expand(
              child: RaisedButton(
                padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
                onPressed: _sendTokenBloc.sendEnabled ? _sendPayment : null,
                color: Colors.blueAccent,
                child: sendAction
              )
            )
          )
        ]
      )
    );
  }
}
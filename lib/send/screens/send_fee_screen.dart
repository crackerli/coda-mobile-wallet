import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/send/blocs/send_bloc.dart';
import 'package:coda_wallet/send/blocs/send_events.dart';
import 'package:coda_wallet/send/blocs/send_states.dart';
import 'package:coda_wallet/send/mutation/send_token_mutation.dart';
import 'package:coda_wallet/send/query/get_account_nonce.dart';
import 'package:coda_wallet/test/test_data.dart';
import 'package:coda_wallet/types/send_data.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/dialog/loading_dialog.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

_gotoTxnDetail(BuildContext context) {
  Navigator.pushReplacementNamed(context, TxnDetailRoute, arguments: null);
}

class SendFeeScreen extends StatefulWidget {

  SendFeeScreen({Key key}) : super(key: key);

  @override
  _SendFeeScreenState createState() => _SendFeeScreenState();
}

class _SendFeeScreenState extends State<SendFeeScreen> {
  SendData _sendData;
  SendBloc _sendBloc;

  _send() {
    Map<String, dynamic> variables = Map<String, dynamic>();
    variables['from'] = _sendBloc.from;
    variables['to'] = _sendBloc.to;
    variables['amount'] = getNanoMina(_sendBloc.amount);
    variables['memo'] = _sendBloc.memo;
    variables['fee'] = getNanoMina(_sendBloc.fee);
    variables['nonce'] = _sendBloc.nonce;
    variables['validUntil'] = 65535;
    // variables['from'] = 'B62qiy32p8kAKnny8ZFwoMhYpBppM1DWVCqAPBYNcXnsAHhnfAAuXgg';
    // variables['to'] = 'B62qrPN5Y5yq8kGE3FbVKbGTdTAJNdtNtB5sNVpxyRwWGcDEhpMzc8g';
    // variables['amount'] = 420000000;
    // variables['memo'] = 'this is a memo';
    // variables['fee'] = 300000000;
    // variables['nonce'] = 200;
    // variables['token'] = 1;
    // variables['validUntil'] = 10000;
    // variables['field'] = '6294031020844169724778227166138415676049686510656401727312236286674679501948';
    // variables['scalar'] = '4626454670027815473460098193984318559610067435921261084455739892582590642453';

    _sendBloc.add(
      Send(SEND_PAYMENT_MUTATION, variables: variables));
  }
  
  _getNonce() {
    // Map<String, dynamic> variables = Map<String, dynamic>();
    // variables['publicKey'] = _sendBloc.from;
    // _sendBloc.add(
    //   GetNonce(GET_NONCE_QUERY, variables: variables));
    _gotoTxnDetail(context);
  }

  @override
  void initState() {
    super.initState();
    _sendBloc = BlocProvider.of<SendBloc>(context);
  }

  @override
  void dispose() {
    _sendBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    _sendData = ModalRoute.of(context).settings.arguments;
    // Default fee to be 0.1
    _sendData.fee = '0.1';

    _sendBloc.from = testAccounts[_sendData.from].address;
    _sendBloc.amount = _sendData.amount;
    _sendBloc.memo = _sendData.memo;
    _sendBloc.fee = _sendData.fee;
    _sendBloc.to = _sendData.to;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildNoTitleAppBar(context),
      body: Container(
        child: BlocBuilder<SendBloc, SendStates>(
          builder: (BuildContext context, SendStates state) {
            return Stack(
              alignment: Alignment.center,
              children: [
                _buildSendFeeBody(context),
                _buildActionsButton(context, state)
              ]
            );
          }
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.bottomCenter,
            image: AssetImage('images/common_bg.png',),
            fit: BoxFit.fitWidth
          ),
        ),
      )
    );
  }
  
  _buildActionsButton(BuildContext context, SendStates state) {
    if(state is GetNonceLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ProgressDialog.showProgress(context);
      });
    }

    if(state is GetNonceFail || state is SendFail) {
      ProgressDialog.dismiss(context);
    }

    if(state is GetNonceSuccess) {
      _send();
    }

    if(state is SendSuccess) {
      ProgressDialog.dismiss(context);
      _gotoTxnDetail(context);
    }

    return Positioned(
      bottom: 60.h,
      child: InkWell(
        onTap: _getNonce,
        child: Container(
          padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 100.w, right: 100.w),
          decoration: getMinaButtonDecoration(topColor: Color(0xff9fe4c9)),
          child: Text('SEND',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
        ),
      )
    );
  }

  _buildSendFeeBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(height: 30.h,),
        Text('Transaction Summary', textAlign: TextAlign.center, style: TextStyle(fontSize: 28.sp, color: Color(0xff2d2d2d))),
        Container(height: 17.h,),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.only(top: 33.w, left: 50.w, right: 50.w),
              padding: EdgeInsets.only(top: 33.w + 12.h, left: 37.w, right: 37.w, bottom: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.w),
                color: Colors.white,
                border: Border.all(color: Color(0xff2d2d2d), width: 1.w)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('FROM', textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
                  Text(testAccounts[_sendData.from].address,
                      textAlign: TextAlign.left, style: TextStyle(fontSize: 14.sp, color: Color(0xff2d2d2d))),
                  Container(height: 10.h),
                  Text('TO',  textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
                  Text(_sendData.to,
                      textAlign: TextAlign.left, style: TextStyle(fontSize: 14.sp, color: Color(0xff2d2d2d))),
                  Container(height: 10.h),
                  Text('AMOUNT',
                    textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: '${_sendData.amount} ',
                        style: TextStyle(fontSize: 20.sp, color: Color(0xff2d2d2d))),
                      TextSpan(
                        text: 'MINA',
                        style: TextStyle(color: Color(0xff616161), fontSize: 12.sp)
                      )]
                    )
                  ),
                  Text('(\$353.62)', textAlign: TextAlign.left, style: TextStyle(fontSize: 16.sp, color: Color(0xff616161)),),
                  Container(height: 10.h,),
                  Text('MEMO',
                    textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
                  Text('${_sendData.memo}', textAlign: TextAlign.left, style: TextStyle(fontSize: 14.sp, color: Color(0xff2d2d2d)),),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: Image.asset('images/mina_logo_black_inner.png', width: 66.w, height: 66.w,)
            )
          ],
        ),
        Container(height: 28.h,),
        Text('NETWORK FEE',
          textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
        Text('${_sendData.fee}', textAlign: TextAlign.left, style: TextStyle(fontSize: 14.sp, color: Color(0xff2d2d2d))),
      ],
    );
  }
}

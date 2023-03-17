import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/send/blocs/send_bloc.dart';
import 'package:coda_wallet/send/blocs/send_events.dart';
import 'package:coda_wallet/send/blocs/send_states.dart';
import 'package:coda_wallet/send/query/get_pooled_fee.dart';
import 'package:coda_wallet/txn_detail/blocs/txn_entity.dart';
import 'package:coda_wallet/types/send_data.dart';
import 'package:coda_wallet/types/send_error_type.dart';
import 'package:coda_wallet/types/transaction_type.dart';
import 'package:coda_wallet/types/txn_status_type.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/dialog/loading_dialog.dart';
import 'package:coda_wallet/widget/dialog/decrypt_seed_dialog.dart';
import 'package:coda_wallet/widget/dialog/send_error_dialog.dart';
import 'package:coda_wallet/widget/fee/fee_clipper.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:coda_wallet/widget/ui/custom_gradient.dart';
import 'package:ffi_mina_signer/util/mina_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

_gotoTxnDetail(BuildContext context, SendData sendData) {
  TxnType txnType;
  if(sendData.isDelegation) {
    txnType = TxnType.DELEGATION;
  } else {
    txnType = TxnType.SEND;
  }

  TxnEntity txnEntity = TxnEntity(globalHDAccounts.accounts![sendData.from]!.address!,
    sendData.to, null, sendData.amount, sendData.fee!, sendData.memo, TxnStatus.PENDING, txnType, true, null, null);
  Navigator.pushReplacementNamed(context, TxnDetailRoute, arguments: txnEntity);
}

class SendFeeScreen extends StatefulWidget {

  SendFeeScreen({Key? key}) : super(key: key);

  @override
  _SendFeeScreenState createState() => _SendFeeScreenState();
}

class _SendFeeScreenState extends State<SendFeeScreen> {
  late SendData _sendData;
  late var _sendBloc;
  var _eventBusOn;

  _checkFeeChosen(BuildContext context) {
    if(_sendBloc.feeIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please choose fee!!')));
    } else {
      showDecryptSeedDialog(context, SendFeeRoute);
    }
  }

  _getPooledFee() {
    Map<String, dynamic> variables = Map<String, dynamic>();
    _sendBloc.add(GetPooledFee(POOLED_FEE_QUERY, variables: variables));
  }

  @override
  void initState() {
    super.initState();
    _sendBloc = BlocProvider.of<SendBloc>(context);
    _eventBusOn = eventBus.on<SendEventBus>().listen((event) async {
      if(event is SendPasswordInput) {
        _sendBloc.add(DecryptSeed(event.password));
        return;
      }

      if(event is SendActionsAgain) {
        _sendBloc.add(SendActions());
      }

      if(event is GetPooledFeeAgain) {
        _getPooledFee();
        return;
      }

      if(event is UserCancelSend) {
        _sendBloc.add(UserCancel());
      }
    });
    _getPooledFee();
  }

  @override
  void dispose() {
    _sendBloc = null;
    _eventBusOn.cancel();
    _eventBusOn = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true, splitScreenMode: false, scaleByHeight: false);
    print('SendFeeScreen: build(context: $context)');
    _sendData = ModalRoute.of(context)!.settings.arguments as SendData;

    _sendBloc.from              = globalHDAccounts.accounts![_sendData.from]!.address;
    _sendBloc.amount            = _sendData.amount;
    _sendBloc.memo              = _sendData.memo;
    _sendBloc.fee               = _sendData.fee;
    _sendBloc.to                = _sendData.to;
    _sendBloc.accountIndex      = _sendData.from;
    _sendBloc.isDelegation      = _sendData.isDelegation;
    _sendBloc.isEverstake       = _sendData.isEverstake;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildNoTitleAppBar(context),
      body: Container(
        child: BlocBuilder<SendBloc, SendStates>(
          builder: (BuildContext context, SendStates state) {
            return Stack(
              alignment: Alignment.center,
              children: [
                _buildSendFeeBody(context, state),
                _buildActionsButton(context, state)
              ]
            );
          }
        ),
        decoration: BoxDecoration(
          gradient: backgroundGradient
        ),
      )
    );
  }
  
  _buildActionsButton(BuildContext context, SendStates state) {

    if(state is SendActionsLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ProgressDialog.showProgress(context);
      });
    }

    if(state is SendActionsFail) {
      ProgressDialog.dismiss(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSendErrorDialog(context, SendErrorType.SEND_ACTIONS, state.error);
      });
    }

    if(state is SendActionsSuccess) {
      ProgressDialog.dismiss(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendData.fee = _sendBloc.bestFees[_sendBloc.feeIndex].toString();
        _gotoTxnDetail(context, _sendData);
      });
    }

    return Positioned(
      bottom: 60.h,
      child: Builder(builder: (context) => InkWell(
        onTap: () => _checkFeeChosen(context),
        child: Container(
          padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 124.w, right: 124.w),
          decoration: getMinaButtonDecoration(topColor: Colors.white),
          child: Text('SEND',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
        ),
      )
    ));
  }

  _feeItemBorderRadius(int index) {
    if(0 == index) {
      return BorderRadius.only(topLeft: Radius.circular(5.w), bottomLeft: Radius.circular(5.w));
    }

    if(1 == index) {
      return BorderRadius.all(Radius.zero);
    }

    return BorderRadius.only(topRight: Radius.circular(5.w), bottomRight: Radius.circular(5.w));
  }
  
  _buildFeeItem(int index, bool selected, String speed, String feeToken, String feeFiat) {
    return InkWell(child:
      Container(
      decoration: BoxDecoration(
        borderRadius: _feeItemBorderRadius(index),
        color: selected ? Color(0xffbfb556) : Colors.white,
        border: Border.all(color: Color(0xff2d2d2d), width: 0.5.w)
      ),
      padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 6.w, bottom: 6.w),
      child: Stack(
        children: [
          ClipPath(
            clipper: FeeClipper(),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 12.h, bottom: 12.h),
              child: Column(
                children: [
                  Text(speed, textAlign: TextAlign.center, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),),
                  Container(height: 4.h,),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: '$feeToken ',
                        style: TextStyle(fontSize: 12.sp, color: Colors.black, fontWeight: FontWeight.bold)
                      ),
                      TextSpan(
                        text: 'MINA',
                        style: TextStyle(color: Color(0xff979797), fontWeight: FontWeight.normal, fontSize: 8.sp)
                      ),
                    ]),
                  ),
                  Container(height: 1.h,),
                  Text('(\$$feeFiat)', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: Color(0xff2d2d2d))),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: selected ? Image.asset('images/fee_selected.png', width: 10.w, height: 10.w,) : Container()
          )
        ]
      )),
      onTap: () => _sendBloc.add(ChooseFee(index)),
    );
  }

  _buildSendFeeBody(BuildContext context, state) {
    if(state is DecryptSeedFail) {
      ProgressDialog.dismiss(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong password!!')));
      });
      _sendBloc.add(ClearWrongPassword());
    }

    if(state is DecryptSeedSuccess) {
      ProgressDialog.dismiss(context);
      _sendBloc.add(SendActions());
    }

    if(state is GetPooledFeeLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ProgressDialog.showProgress(context);
      });
    }

    List<BigInt> bestFees = _sendBloc.bestFees;

    if(state is GetPooledFeeFail) {
      ProgressDialog.dismiss(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSendErrorDialog(context, SendErrorType.GET_POOL_FEE, state.error);
      });
    }

    if(state is GetPooledFeeSuccess) {
      bestFees = state.data as List<BigInt>;
      ProgressDialog.dismiss(context);
    }

    int feeIndex = _sendBloc.feeIndex;
    if(state is FeeChosen) {
      feeIndex = state.index;
    }

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
              margin: EdgeInsets.only(top: 33.w, left: 48.w, right: 48.w),
              padding: EdgeInsets.only(top: 18.w + 12.h, left: 20.w, right: 20.w, bottom: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.w),
                color: Colors.white,
                border: Border.all(color: Color(0xff2d2d2d), width: 1.w)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('TYPE', textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
                  Text((_sendBloc.isDelegation ?? false) ? 'Delegation' : 'Payment',
                      textAlign: TextAlign.left, style: TextStyle(fontSize: 14.sp, color: Color(0xff2d2d2d))),
                  Container(height: 10.h),
                  Text('FROM', textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
                  Text(globalHDAccounts.accounts![_sendData.from]!.address ?? '',
                      textAlign: TextAlign.left, style: TextStyle(fontSize: 14.sp, color: Color(0xff2d2d2d))),
                  Container(height: 10.h),
                  Text('TO',  textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
                  Text(_sendData.to,
                      textAlign: TextAlign.left, style: TextStyle(fontSize: 14.sp, color: Color(0xff2d2d2d))),
                  !_sendBloc.isDelegation ?
                  Container(height: 10.h) : Container(),
                  !_sendBloc.isDelegation ?
                  Text('AMOUNT',
                    textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))) : Container(),
                  !_sendBloc.isDelegation ?
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: '${MinaHelper.getMinaStrByNanoNum(_sendBloc.finalAmount)} ',
                        style: TextStyle(fontSize: 20.sp, color: Color(0xff2d2d2d))),
                      TextSpan(
                        text: 'MINA',
                        style: TextStyle(color: Color(0xff616161), fontSize: 12.sp)
                      )]
                    )
                  ) : Container(),
                  !_sendBloc.isDelegation ?
                  Text('(\$${getTokenFiatPrice(_sendBloc.finalAmount.toString())})',
                    textAlign: TextAlign.left, style: TextStyle(fontSize: 16.sp, color: Color(0xff616161))) : Container(),
                  (_sendData.memo != null && _sendData.memo!.trim().isNotEmpty) ? Container(height: 10.h,) : Container(),
                  (_sendData.memo != null && _sendData.memo!.trim().isNotEmpty) ? Text('MEMO',
                    textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))) : Container(),
                  (_sendData.memo != null && _sendData.memo!.trim().isNotEmpty) ? Text('${_sendData.memo}',
                    textAlign: TextAlign.left, style: TextStyle(fontSize: 14.sp, color: Color(0xff2d2d2d))) : Container(),
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
        Container(height: 10.h,),
        Container(
          margin: EdgeInsets.only(left: 48.w, right: 48.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.w),
            shape: BoxShape.rectangle,
            border: Border.all(width: 0.5.w, color: Colors.black),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _buildFeeItem(0, 0 == feeIndex, 'MODERATE',
                  formatFeeAsFixed(bestFees[0], 3), getTokenFiatPrice(bestFees[0].toString())),
                flex: 1,
              ),
              Expanded(
                child: _buildFeeItem(1, 1 == feeIndex, 'FAST',
                  formatFeeAsFixed(bestFees[1], 3), getTokenFiatPrice(bestFees[1].toString())),
                flex: 1,
              ),
              Expanded(
                child: _buildFeeItem(2, 2 == feeIndex, 'VERY FAST',
                  formatFeeAsFixed(bestFees[2], 3), getTokenFiatPrice(bestFees[2].toString())),
                flex: 1,
              )
            ],
          )
        )
      ]
    );
  }
}

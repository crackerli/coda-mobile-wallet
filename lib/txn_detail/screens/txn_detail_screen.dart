import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/txn_detail/blocs/txn_entity.dart';
import 'package:coda_wallet/types/transaction_type.dart';
import 'package:coda_wallet/types/txn_status_type.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:ffi_mina_signer/sdk/mina_signer_sdk.dart';
import 'package:ffi_mina_signer/util/mina_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

const FLEX_LEFT_LABEL = 3;
const FLEX_RIGHT_CONTENT = 10;

class TxnDetailScreen extends StatefulWidget {

  TxnDetailScreen({Key? key}) : super(key: key);

  @override
  _TxnDetailScreenState createState() => _TxnDetailScreenState();
}

class _TxnDetailScreenState extends State<TxnDetailScreen> {

  late TxnEntity _txnEntity;
  late String _decodedMemo;
  late bool _showMemo;
  bool _txHashCopied = false;

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
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true, splitScreenMode: false, scaleByHeight: false);
    _txnEntity = ModalRoute.of(context)!.settings.arguments as TxnEntity;
    _getReadableMemo();
    return Scaffold(
      backgroundColor: Color(0xfff1f1f1),
      appBar: buildTitleAppBar(context, 'Transaction Details', actions: false),
      body: SafeArea(
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildTxnDetailBody(context),
              _buildActionsButton(context),
            ]
          ),
        ),
      )
    );
  }

  _buildTxnDetailBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(height: 28.h),
        _getTxnStatusIcon(),
        Container(height: 2.h,),
        _getTxnStatusText(),
        (_txnEntity.txnStatus == TxnStatus.PENDING) ? Container() :
        Container(height: 10.h,),
        _getDateTime(),
        Container(height: 23.h,),
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 0.5.w),
            borderRadius: BorderRadius.all(Radius.circular(10.w)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: FLEX_LEFT_LABEL,
                    child: Text('Details', textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff9397a2)),)
                  ),
                  Expanded(
                    flex: FLEX_RIGHT_CONTENT,
                    child: Text(_getTxnTypeStr(), textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff1d1d1d)))
                  )
                ],
              ),
              Container(height: 10.h,),
              Row(
                children: [
                  Expanded(
                    flex: FLEX_LEFT_LABEL,
                    child: Container()
                  ),
                  Expanded(
                    flex: FLEX_RIGHT_CONTENT,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${MinaHelper.getMinaStrByNanoStr(_txnEntity.amount)}', textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff1d1d1d))),
                        Text('MINA', textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: Color(0xff1d1d1d))),
                      ],
                    )
                  )
                ],
              ),
              Container(height: 10.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: FLEX_LEFT_LABEL,
                    child: Container()
                  ),
                  Expanded(
                    flex: FLEX_RIGHT_CONTENT,
                    child: Container(height: 1.h, color: Color(0xffeeeef0),)
                  ),
                ],
              ),
              Container(height: 10.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: FLEX_LEFT_LABEL,
                    child: Text('Fee', textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff9397a2)))
                  ),
                  Expanded(
                    flex: FLEX_RIGHT_CONTENT,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${MinaHelper.getMinaStrByNanoStr(_txnEntity.fee)}', textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff1d1d1d))),
                        Text('MINA', textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: Color(0xff1d1d1d)))
                      ],
                    )
                  ),
                ],
              ),
              !_showMemo ? Container() :
              Container(height: 10.h,),
              !_showMemo ? Container() :
              Container(height: 1.h, color: Color(0xffeeeef0),),
              !_showMemo ? Container() :
              Container(height: 10.h,),
              !_showMemo ? Container() :
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: FLEX_LEFT_LABEL,
                    child: Text('Memo', textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff9397a2)))
                  ),
                  Expanded(
                    flex: FLEX_RIGHT_CONTENT,
                    child: Text(_decodedMemo, textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff1d1d1d)))
                  ),
                ],
              ),
              (null == _txnEntity.failureReason || (_txnEntity.failureReason as String).isEmpty) ? Container() :
              Container(height: 10.h,),
              (null == _txnEntity.failureReason || (_txnEntity.failureReason as String).isEmpty) ? Container() :
              Container(height: 1.h, color: Color(0xffeeeef0),),
              (null == _txnEntity.failureReason || (_txnEntity.failureReason as String).isEmpty) ? Container() :
              Container(height: 10.h,),
              (null == _txnEntity.failureReason || (_txnEntity.failureReason as String).isEmpty) ? Container() :
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: FLEX_LEFT_LABEL,
                    child: Text('Failure', textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff9397a2)))
                  ),
                  Expanded(
                    flex: FLEX_RIGHT_CONTENT,
                    child: Text('${_txnEntity.failureReason ?? 'null'}', textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff1d1d1d)))
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(height: 18.h,),
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 0.5.w),
            borderRadius: BorderRadius.all(Radius.circular(10.w)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: FLEX_LEFT_LABEL,
                    child: Text('From', textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff9397a2)))
                  ),
                  Expanded(
                    flex: FLEX_RIGHT_CONTENT,
                    child: Text(_txnEntity.from, textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff1d1d1d)))
                  ),
                ],
              ),
              Container(height: 10.h,),
              Container(height: 1.h, color: Color(0xffeeeef0),),
              Container(height: 10.h,),
              Row(
                children: [
                  Expanded(
                    flex: FLEX_LEFT_LABEL,
                    child: Text('To', textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff9397a2)))
                  ),
                  Expanded(
                    flex: FLEX_RIGHT_CONTENT,
                    child: Text(_txnEntity.to, textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff1d1d1d)))
                  ),
                ],
              )
          ],
        )),
        Container(height: 18.h,),
        (null == _txnEntity.txnHash || _txnEntity.txnHash!.isEmpty) ? Container() :
        Container(
          margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 0.5.w),
            borderRadius: BorderRadius.all(Radius.circular(10.w)),
            color: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: FLEX_LEFT_LABEL,
                child: Text('TxHash', textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff9397a2)),)
              ),
              Expanded(
                flex: FLEX_RIGHT_CONTENT,
                child: Container(
                  padding: EdgeInsets.fromLTRB(2.w, 2.h, 2.w, 2.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.5.w),
                    borderRadius: BorderRadius.all(Radius.circular(3.w)),
                    color: _txHashCopied ? Colors.grey : Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: _txnEntity.txnHash ?? 'null'));
                          setState(() {
                            _txHashCopied = true;
                          });
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transaction hash copied into clipboard!')));
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 4.w),
                          child: Image.asset(_txHashCopied ? 'images/copy_white.png' : 'images/copy_gray.png', width: 22.w, height: 22.h),
                        )
                      ),
                      Expanded(
                        child:
                          Text(_txnEntity.txnHash!, textAlign: TextAlign.start, maxLines: 2,
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: _txHashCopied ? Colors.white : Color(0xff1d1d1d))))
                  ],
                )
              )),
            ],
          ),
        ),
      ],
    );
  }

  _getTxnStatusIcon() {
    if(_txnEntity.txnStatus == TxnStatus.PENDING) {
      return Image.asset('images/txn_pending.png', width: 60.w, height: 60.w,);
    }

    if(_txnEntity.txnStatus == TxnStatus.CONFIRMED && null == _txnEntity.failureReason) {
      return Image.asset('images/txn_success.png', width: 60.w, height: 60.w,);
    }

    if(_txnEntity.txnStatus == TxnStatus.CONFIRMED && null != _txnEntity.failureReason) {
      return Image.asset('images/txn_wrong.png', width: 60.w, height: 60.w,);
    }

    return Container();
  }

  _getTxnStatusText() {
    if(_txnEntity.txnStatus == TxnStatus.PENDING) {
      return Text('Pending...', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Color(0xff098de6)));
    }

    if(_txnEntity.txnStatus == TxnStatus.CONFIRMED && null == _txnEntity.failureReason) {
      return Text('Successful', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Color(0xff6bc7a1)));
    }

    if(_txnEntity.txnStatus == TxnStatus.CONFIRMED && null != _txnEntity.failureReason) {
      return Text('Failed', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Color(0xfffe5962)));
    }

    return Container();
  }

  _getDateTime() {
    if(_txnEntity.txnStatus == TxnStatus.PENDING) {
      return Container();
    } else {
      String dateTimeStr =  DateFormat().format(
          DateTime.fromMillisecondsSinceEpoch(int.tryParse(_txnEntity.timestamp!)!));
      return Text(dateTimeStr, textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Color(0xffacadb5)),);
    }
  }

  String _getTxnTypeStr() {
    if(_txnEntity.txnType == TxnType.RECEIVE) {
      return 'Receive';
    }

    if(_txnEntity.txnType == TxnType.SEND) {
      return 'Send';
    }

    if(_txnEntity.txnType == TxnType.DELEGATION) {
      return 'Stake';
    }

    return 'Unknown';
  }

  _buildActionsButton(BuildContext context) {
    return Positioned(
      bottom: 30.h,
      child: SizedBox(
        width: 300.w,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
            foregroundColor: Color(0xff098de6),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
            side: BorderSide(width: 1.w, color: Color(0xff098de6))
          ),
          onPressed: () {
            if(null == _txnEntity.txnHash || _txnEntity.txnHash!.isEmpty) {
              openUrl('https://minaexplorer.com/wallet/${_txnEntity.from}');
            } else {
              openUrl('https://minaexplorer.com/transaction/${_txnEntity.txnHash}');
            }
          },
          child: Text('VIEW IN EXPLORER', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff098de6)))
        )
      )
    );
  }

  _getReadableMemo() {
    if(null == _txnEntity.memo || _txnEntity.memo!.trim().isEmpty) {
      _decodedMemo = '';
      _showMemo = false;
      return;
    }

    if(_txnEntity.isIndexerMemo) {
      // Memo get from figment service, the string has been decoded.
      _decodedMemo = _txnEntity.memo ?? '';
    } else {
      // Memo get from Mina node, need to decoded the human readable string.
      _decodedMemo = decodeBase58Check(_txnEntity.memo ?? '');
    }

    if(_decodedMemo.trim().isEmpty) {
      _showMemo = false;
      return;
    }

    _showMemo = true;
  }
}
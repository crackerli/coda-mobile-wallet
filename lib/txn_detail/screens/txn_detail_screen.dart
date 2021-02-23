import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/txn_detail/blocs/txn_entity.dart';
import 'package:coda_wallet/types/transaction_type.dart';
import 'package:coda_wallet/types/txn_status_type.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:coda_wallet/widget/ui/custom_gradient.dart';
import 'package:ffi_mina_signer/sdk/mina_signer_sdk.dart';
import 'package:ffi_mina_signer/util/mina_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TxnDetailScreen extends StatefulWidget {

  TxnDetailScreen({Key key}) : super(key: key);

  @override
  _TxnDetailScreenState createState() => _TxnDetailScreenState();
}

class _TxnDetailScreenState extends State<TxnDetailScreen> {
  TxnEntity _txnEntity;

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
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    _txnEntity = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildNoTitleAppBar(context, leading: false),
      body: SafeArea(
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildSendFeeBody(),
              _buildActionsButton(context),
            ]
          ),
          decoration: BoxDecoration(
            gradient: backgroundGradient
          ),
        ),
      )
    );
  }

  _buildActionsButton(BuildContext context) {
    return Positioned(
      bottom: 60.h,
      child: InkWell(
        onTap: () => openUrl('https://minaexplorer.com/wallet/${_txnEntity.from}'),
        child: Container(
          padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 40.w, right: 40.w),
          decoration: getMinaButtonDecoration(topColor: Color(0xffe0e0e0)),
          child: Text('VIEW IN BLOCK EXPLORER',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
        ),
      )
    );
  }

  String getTxnStatusStr() {
    if(_txnEntity.txnStatus == TxnStatus.PENDING) {
      return 'Transaction Pending';
    }
    if(_txnEntity.txnType == TxnType.RECEIVE) {
      return 'Transaction received';
    }

    if(_txnEntity.txnType == TxnType.SEND) {
      return 'Transaction sent';
    }

    if(_txnEntity.txnType == TxnType.DELEGATION) {
      return 'Transaction Staked';
    }

    return 'Unknown';
  }

  getTxnTypeIcon() {
    if(_txnEntity.txnStatus == TxnStatus.PENDING) {
      return Image.asset('images/txn_pending.png', width: 52.w, height: 52.w);
    }
    if(_txnEntity.txnType == TxnType.RECEIVE) {
      return Image.asset('images/txn_receive.png', width: 52.w, height: 52.w);
    }

    if(_txnEntity.txnType == TxnType.SEND) {
      return Image.asset('images/txn_send.png', width: 52.w, height: 52.w);
    }

    if(_txnEntity.txnType == TxnType.DELEGATION) {
      return Image.asset('images/txn_stake.png', width: 52.w, height: 52.w);
    }

    return Container();
  }

  _buildSendFeeBody() {
    return Container(
      padding: EdgeInsets.only(left: 50.w, right: 50.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(height: 23.h),
          Center(child: getTxnTypeIcon()),
          Container(height: 15.h),
          Center(
            child: Text(getTxnStatusStr(), textAlign: TextAlign.left,
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.normal, color: Color(0xff2d2d2d))
            )
          ),
          Container(height: 28.h),
          Container(
            width: double.infinity,
            height: 1.h,
            color: Color(0xff757575)),
          Container(height: 2.h,),
          Container(
            width: double.infinity,
            height: 1.h,
            color: Color(0xff757575)),
          Container(height: 28.h,),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text('FROM', textAlign: TextAlign.right, maxLines: 2,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d))),
              ),
              Container(width: 8.w,),
              Expanded(
                flex: 2,
                child: Text(_txnEntity.from,
                  textAlign: TextAlign.left, maxLines: 3,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal, color: Color(0xff616161))),
              )
            ],
          ),
          Container(height: 16.h),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text('TO', textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d))),
              ),
              Container(width: 8.w,),
              Expanded(
                flex: 2,
                child: Text(_txnEntity.to,
                  textAlign: TextAlign.left, maxLines: 3,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.normal, color: Color(0xff616161))),
              )
            ],
          ),
          Container(height: 16.h),
          _txnEntity.txnStatus != TxnStatus.PENDING ?
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text('TIMESTAMP', textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d)),),
              ),
              Container(width: 8.w,),
              Expanded(
                flex: 2,
                child: Text(formatDateTime(_txnEntity.timestamp),
                  textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, color: Color(0xff616161)),),
              )
            ],
          ) : Container(),
          _txnEntity.txnStatus != TxnStatus.PENDING ? Container(height: 16.h) : Container(),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text('AMOUNT', textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d))),
              ),
              Container(width: 8.w,),
              Expanded(
                flex: 2,
                child: Text('${MinaHelper.getMinaStrByNanoStr(_txnEntity.amount)} MINA', maxLines: 3,
                  textAlign: TextAlign.left, style: TextStyle(fontSize: 13.sp, color: Color(0xff616161))),
              )
            ],
          ),
          Container(height: 16.h,),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text('FEE', textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d)),),
              ),
              Container(width: 8.w,),
              Expanded(
                flex: 2,
                child: Text('${MinaHelper.getMinaStrByNanoStr(_txnEntity.fee)} MINA', textAlign: TextAlign.left, maxLines: 2,
                  style: TextStyle(fontSize: 13.sp,  color: Color(0xff616161))),
              )
            ],
          ),
          Container(height: 16.h,),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text('TOTAL', textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d)),),
              ),
              Container(width: 8.w,),
              Expanded(
                flex: 2,
                child: Text('${MinaHelper.getMinaStrByNanoStr(_txnEntity.total)} MINA', textAlign: TextAlign.left, maxLines: 2,
                    style: TextStyle(fontSize: 13.sp,  color: Color(0xff616161))),
              )
            ],
          ),
          Container(height: 16.h,),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text('MEMO', textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Color(0xff2d2d2d)),),
              ),
              Container(width: 8.w,),
              Expanded(
                flex: 2,
                child: Text('${decodeBase58Check(_txnEntity.memo)}', textAlign: TextAlign.left, maxLines: 2,
                  style: TextStyle(fontSize: 13.sp,  color: Color(0xff616161))),
              )
            ],
          ),
          Container(height: 28.h),
          Container(
            width: double.infinity,
            height: 1.h,
            color: Color(0xff757575)),
          Container(height: 2.h,),
          Container(
            width: double.infinity,
            height: 1.h,
            color: Color(0xff757575)),
        ]
      )
    );
  }
}

import 'package:coda_wallet/account_txns/blocs/account_txns_entity.dart';
import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TxnDetailScreen extends StatefulWidget {
  final MergedUserCommand mergedUserCommand;
  final String publicKey;

  const TxnDetailScreen({
    this.mergedUserCommand,
    this.publicKey,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TxnDetailScreenState();
}

class _TxnDetailScreenState extends State<TxnDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildAccountTxnsAppBar() {
    return PreferredSize(
      child: AppBar(
        title: Text('Transaction Detail',
          style: TextStyle(fontSize: APPBAR_TITLE_FONT_SIZE.sp, color: Color(0xff0b0f12))),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          tooltip: 'Navigation',
          onPressed: () => Navigator.pop(context, ''),
        ),
      ),
      preferredSize: Size.fromHeight(APPBAR_HEIGHT.h)
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(1080, 2316), allowFontScaling: false);
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Color(0xfff5f8fd),
        appBar: _buildAccountTxnsAppBar(),
        body: _buildTxnAccountBody(),
      ),
      onWillPop: () async {
        Navigator.pop(context, '');
        return true;
      }
    );
  }

  Widget _buildTxnAccountBody() {
    return Padding(
      padding: EdgeInsets.only(left: globalHPadding.w, right: globalHPadding.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTxnStatus(),
          _buildTxnAmount(),
          _buildTxnContent(),
          _buildTxnId()
        ]
      )
    );
  }

  Widget _buildTxnStatus() {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('images/tx_success.png', width: 60, height: 60,),
          Container(height: 12),
          Text('Success', style: TextStyle(color: Color(0xff7dc2ad))),
          Container(height: 6,),
          Text('2020-10-23 16:21', style: TextStyle(color: Color(0xff9d9d9d)),),
        ],
      )
    );
  }

  Widget _buildTxnAmount() {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Amount', textAlign: TextAlign.left, style: TextStyle(color: Color(0xff9d9d9d))),
            Text('10.2344556 Mina', textAlign: TextAlign.right, style: TextStyle(color: Color(0xff0a0a0a), fontWeight: FontWeight.bold)),
          ],
        )
      )
    );
  }

  Widget _buildTxnContent() {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Fee', textAlign: TextAlign.left, style: TextStyle(color: Color(0xff9d9d9d)),),
                Text('0.000378 Mina', textAlign: TextAlign.right, style: TextStyle(color: Color(0xff0f0f0f)),),
              ]
            ),
            Container(height: 8),
            Container(height: 1, color: Color(0xff9d9d9d),),
            Container(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Receiver', textAlign: TextAlign.left, style: TextStyle(color: Color(0xff9d9d9d)),),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.only(left: 12),
                    child: Text('B62qmJFzhkdVcx75hLVAt3RNAs3wQV76unWtj9YhQ91w18acBVJTo6Q',
                    textAlign: TextAlign.right, style: TextStyle(color: Color(0xff0f0f0f), fontSize: 11), maxLines: 3, overflow: TextOverflow.ellipsis),
                  )
                )
              ],
            ),
            Container(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Sender', textAlign: TextAlign.left, style: TextStyle(color: Color(0xff9d9d9d)),),
                ),
                Expanded(
                    flex: 7,
                    child: Container(
                      padding: EdgeInsets.only(left: 12),
                      child: Text('B62qmJFzhkdVcx75hLVAt3RNAs3wQV76unWtj9YhQ91w18acBVJTo6Q',
                          textAlign: TextAlign.right, style: TextStyle(color: Color(0xff0f0f0f), fontSize: 11), maxLines: 3, overflow: TextOverflow.ellipsis),
                    )
                )
              ],
            ),
            Container(height: 8),
            Container(height: 1, color: Color(0xff9d9d9d),),
            Container(height: 8),
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Memo', textAlign: TextAlign.left, style: TextStyle(color: Color(0xff9d9d9d)),),
                  Text('Test1', textAlign: TextAlign.right, style: TextStyle(color: Color(0xff0f0f0f)),),
                ]
            ),
          ],
        )
      ),
    );
  }

  Widget _buildTxnId() {
    return Card(
      child: Padding(padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 2,
                child: Text('Sender', textAlign: TextAlign.left, style: TextStyle(color: Color(0xff9d9d9d)),),
              ),
              Expanded(
                  flex: 7,
                  child: Container(
                    padding: EdgeInsets.only(left: 12),
                    child:
                      Text('B62qmJFzhkdVcx75hLVAt3RNAs3wQV76unWtj9YhQ91w18acBVJTo6Q',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Color(0xff0f0f0f), fontSize: 11), maxLines: 3, overflow: TextOverflow.ellipsis),
                  )
              )
            ],
          ),
          Container(height: 8),
          Container(height: 1, color: Color(0xff9d9d9d),),
          Container(height: 8),
          GestureDetector(
            onTap: null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Transcation Detail', textAlign: TextAlign.left, style: TextStyle(color: Color(0xff9d9d9d)),),
                Image.asset('images/navigate_next.png', height: 24, width: 24,),
              ],
            ),
          )
        ]
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
import 'package:coda_wallet/account_txns/blocs/account_txns_entity.dart';
import 'package:coda_wallet/constant/constants.dart';
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
        appBar: _buildAccountTxnsAppBar(),
        body: Container(),
      ),
      onWillPop: () async {
        Navigator.pop(context, '');
        return true;
      }
    );
  }

  _buildTxnAccountBody() {

  }

  @override
  void dispose() {
    super.dispose();
  }
}
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/txns/blocs/txns_bloc.dart';
import 'package:coda_wallet/txns/blocs/txns_entity.dart';
import 'package:coda_wallet/txns/blocs/txns_events.dart';
import 'package:coda_wallet/txns/blocs/txns_states.dart';
import 'package:coda_wallet/txns/query/pooled_txns_query.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:coda_wallet/widget/dialog/bottom_sheet_txn_filter_dialog.dart';
import 'package:coda_wallet/widget/dialog/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TxnsScreen extends StatefulWidget {
  TxnsScreen({Key key}) : super(key: key);

  @override
  _TxnsScreenState createState() => _TxnsScreenState();
}

class _TxnsScreenState extends State<TxnsScreen> with AutomaticKeepAliveClientMixin {
  TxnsBloc _txnsBloc;

  _refreshTxns() {
    Map<String, dynamic> variables = Map<String, dynamic>();
    variables['publicKey'] = _txnsBloc.publicKey;
    _txnsBloc.add(RefreshPooledTxns(POOLED_TXNS_QUERY, variables: variables));
  }

  Future<void> _onRefresh() async {
    if(!_txnsBloc.isTxnsLoading) {
      _refreshTxns();
    }
  }

  @override
  void initState() {
    super.initState();
    print('TxnsScreen initState');
    _txnsBloc = BlocProvider.of<TxnsBloc>(context);
    _refreshTxns();
  }

  @override
  void dispose() {
    _txnsBloc = null;
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    print('TxnsScreen build(context=$context)');
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: BlocBuilder<TxnsBloc, TxnsStates>(
        builder: (BuildContext context, TxnsStates state) {
          return Column(
            children: [
              _buildTxnHeader(context),
              Container(height: 2.h,),
              Container(height: 0.5.h, color: Color.fromARGB(74, 60, 60, 67)),
              Expanded(flex: 1, child: _buildTxnBody(context, state))
            ]
          );
        }
      )
    );
  }

  _buildTxnHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 70.w, right: 10.w),
            child: Text(globalHDAccounts.accounts[_txnsBloc.accountIndex].accountName,
              textAlign: TextAlign.left, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600))
          ),
          Positioned(
            right: 20.w,
            child:
            InkWell(
              onTap: () => showTxnFilterBottomSheet(context),
              child: Row(
              children: [
                Image.asset('images/txn_filter.png', width: 12.w, height: 8.h,),
                Container(width: 5.w,),
                Text('ALL', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.sp, color: Color(0xff212121), fontWeight: FontWeight.w500))
              ],
            ))
          )
        ],
      ),
    );
  }

  _buildTxnBody(BuildContext context, TxnsStates state) {
    if(state is RefreshPooledTxnsLoading) {
      if(state.data == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ProgressDialog.showProgress(context);
        });
        return Container();
      }
    }

    if(state is RefreshConfirmedTxnsSuccess) {
      ProgressDialog.dismiss(context);
      return _buildTxnList(context, state.data);
    }

    if(state is RefreshConfirmedTxnsFail) {
      ProgressDialog.dismiss(context);
      return _buildErrorScreen(context, state.error.toString());
    }

    if(state is RefreshPooledTxnsFail) {
      ProgressDialog.dismiss(context);
      return _buildErrorScreen(context, state.error.toString());
    }

    return _buildTxnList(context, _txnsBloc.mergedUserCommands);
  }
  
  _buildTxnList(BuildContext context, List<MergedUserCommand> commands) {
    if(null == commands || commands.length == 0) {
      return Container();
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: null == commands ? 0 : commands.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: _buildTxnItem(commands[index]),
            onTap: null
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          height: 1.h,
          child: Row(
            children: [
              Expanded(flex: 1, child: Container()),
              Expanded(flex: 6, child: Container(color: Color(0xffc1c1c1)))
            ],
          ),
        );
      },
    );
  }

  _buildTxnItem(MergedUserCommand command) {
    FormattedDate formattedDate = getFormattedDate(command.dateTime);
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h, bottom: 15.h),
      child: Row(
        children: [
          command.isPooled ?
          Center(
            child: Image.asset('images/txn_pending.png', width: 23.w, height: 23.w,)
          ) :
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: <TextSpan>[
            TextSpan(
              text: '${formattedDate.month}\n',
              style: TextStyle(fontSize: 11.sp, color: Color(0xff9e9e9e))),
            TextSpan(
              text: '${formattedDate.day}\n',
              style: TextStyle(
                  color: Color(0xff212121),
                  fontWeight: FontWeight.normal,
                  fontSize: 22.sp
              )
            ),
            TextSpan(
              text: '${formattedDate.year}',
              style: TextStyle(
                color: Color(0xff9e9e9e),
                fontWeight: FontWeight.normal,
                fontSize: 11.sp
              )
            ),
          ])),
          Container(width: 20.w,),
          getTxnTypeIcon(command),
          Container(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(getTxnTypeStr(command), textAlign: TextAlign.left, style: TextStyle(fontSize: 18.sp)),
              Text(command.isPooled ? 'Pending' : formattedDate.hms,
                textAlign: TextAlign.left, style: TextStyle(fontSize: 14.sp, color: Color(0xff757575))),
            ],
          ),
          Container(width: 20.w),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('${formatTokenNumber(command.amount)}', textAlign: TextAlign.right, style: TextStyle(fontSize: 18.sp)),
                Text('\$65.34', textAlign: TextAlign.right, style: TextStyle(fontSize: 14.sp, color: Color(0xff757575)))
              ]
            ),
          )
        ],
      ),
    );
  }

  Widget getTxnTypeIcon(MergedUserCommand command) {
    if(command.isDelegation) {
      return Image.asset('images/txn_stake.png', height: 40.w, width: 40.w);
    }

    if(command.from == _txnsBloc.publicKey) {
      return Image.asset('images/txn_send.png', height: 40.w, width: 40.w);
    }

    if(command.to == _txnsBloc.publicKey) {
      return Image.asset('images/txn_receive.png', height: 40.w, width: 40.w);
    }

    return Container();
  }

  String getTxnTypeStr(MergedUserCommand command) {
    if(command.isDelegation) {
      if(command.from == _txnsBloc.publicKey && command.from == command.to) {
        return 'Unstaked';
      }

      if(command.from == _txnsBloc.publicKey) {
        return 'Staked';
      }

      return 'Delegated';
    }

    if(command.from == _txnsBloc.publicKey) {
      return 'Sent';
    }

    if(command.to == _txnsBloc.publicKey) {
      return 'Received';
    }

    return 'Unknown';
  }

  _buildErrorScreen(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(error),
          Container(height: 8.h,),
          RaisedButton(
            padding: EdgeInsets.only(top: 11.h, bottom: 11.h, left: 40.w, right: 40.w),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.w))),
            onPressed: _refreshTxns,
            color: Colors.blueAccent,
            child: Text('Retry', style: TextStyle(fontSize: 17.sp, color: Colors.white, fontWeight: FontWeight.w600))
          )
        ]
      ),
    );
  }

  _buildNoDataScreen(BuildContext context) {
    return Center(
      child: Text('No Transactions found'),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/route/routes.dart';
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

class _TxnsScreenState extends State<TxnsScreen> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, RouteAware {
  TxnsBloc _txnsBloc;
  var _eventBusOn;

  _refreshTxns() {
    // Restore current filter to ALL if refresh the list
    _txnsBloc.currentFilter = 0;
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
    WidgetsBinding.instance.addObserver(this);
    _txnsBloc = BlocProvider.of<TxnsBloc>(context);
    _refreshTxns();
    _eventBusOn = eventBus.on<TxnsEventBus>().listen((event) {
      if(event is UpdateTxns) {
        _refreshTxns();
        return;
      }

      if(event is ChooseAccountTxns) {
        _txnsBloc.accountIndex = event.accountIndex;
//        _refreshTxns();
        _txnsBloc.add(ChangeAccount());
        return;
      }

      if(event is FilterTxnsAll) {
        _txnsBloc.currentFilter = 0;
        _txnsBloc.add(ChangeFilter());
        return;
      }

      if(event is FilterTxnsSent) {
        _txnsBloc.currentFilter = 1;
        _txnsBloc.add(ChangeFilter());
        return;
      }

      if(event is FilterTxnsReceived) {
        _txnsBloc.currentFilter = 2;
        _txnsBloc.add(ChangeFilter());
        return;
      }

      if(event is FilterTxnsStaked) {
        _txnsBloc.currentFilter = 3;
        _txnsBloc.add(ChangeFilter());
        return;
      }
    });
  }

  @override
  void dispose() {
    _eventBusOn.cancel();
    _eventBusOn = null;
    _txnsBloc = null;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshTxns();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    super.didPopNext();
    print('WalletHomeScreen: didPopNext()');
//    _refreshTxns();
  }

  @override
  void didPush() {
    super.didPush();
    print('WalletHomeScreen: didPush()');
  }

  @override
  void didPushNext() {
    final route = ModalRoute.of(context).settings.name;
    print('WalletHomeScreen didPushNext() route: $route');
  }

  @override
  void didPop() {
    final route = ModalRoute.of(context).settings.name;
    print('WalletHomeScreen didPop() route: $route');
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
              _buildTxnHeader(context, state),
              Container(height: 2.h,),
              Container(height: 0.5.h, color: Color.fromARGB(74, 60, 60, 67)),
              Expanded(flex: 1, child: _buildTxnBody(context, state))
            ]
          );
        }
      )
    );
  }

  _buildTxnHeader(BuildContext context, TxnsStates state) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 70.w, right: 10.w),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, TxnsChooseAccountRoute),
              child: Row(
                children: [
                  Text(globalHDAccounts.accounts[_txnsBloc.accountIndex].accountName,
                    textAlign: TextAlign.left, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500)
                  ),
                  Container(width: 4.w,),
                  Image.asset('images/down_expand.png', width: 14.w, height: 14.w,)
                ]
              ),
            )
          ),
          Positioned(
            right: 20.w,
            child:
            InkWell(
              onTap: () => showTxnFilterSheet(context, _txnsBloc.txnFilters, _txnsBloc.currentFilter),
              child: Row(
              children: [
                Image.asset('images/txn_filter.png', width: 12.w, height: 8.h,),
                Container(width: 5.w,),
                Text(_txnsBloc.txnFilters[_txnsBloc.currentFilter], textAlign: TextAlign.center,
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
      List<dynamic> userCommands = state.data as List<dynamic>;
      if(state.data == null || userCommands.length == 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ProgressDialog.showProgress(context);
        });
        return Container();
      }
    }

    if(state is RefreshConfirmedTxnsSuccess) {
      ProgressDialog.dismiss(context);
      List<dynamic> userCommands = state.data as List<dynamic>;
      if(userCommands == null || userCommands.length == 0) {
        return _buildNoDataScreen(context, 'No transactions found!!!\n Be happy to send or receive Mina');
      }
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

    if(state is AccountChanged) {
      _refreshTxns();
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

  _buildNoDataScreen(BuildContext context, String content) {
    return Center(
      child: Text(content, textAlign: TextAlign.center, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500),),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
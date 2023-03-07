import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/txn_detail/blocs/txn_entity.dart';
import 'package:coda_wallet/txns/blocs/txns_bloc.dart';
import 'package:coda_wallet/txns/blocs/txns_entity.dart';
import 'package:coda_wallet/txns/blocs/txns_events.dart';
import 'package:coda_wallet/txns/blocs/txns_states.dart';
import 'package:coda_wallet/txns/constant/txns_filter_constant.dart';
import 'package:coda_wallet/txns/query/pooled_txns_query.dart';
import 'package:coda_wallet/types/transaction_type.dart';
import 'package:coda_wallet/types/txn_status_type.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:coda_wallet/widget/dialog/bottom_sheet_txn_filter_dialog.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:ffi_mina_signer/util/mina_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../types/mina_hd_account_type.dart';
import '../../widget/app_bar/app_bar.dart';

class TxnsScreen extends StatefulWidget {
  TxnsScreen({Key? key}) : super(key: key);

  @override
  _TxnsScreenState createState() => _TxnsScreenState();
}

class _TxnsScreenState extends State<TxnsScreen> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, RouteAware {
  late var _txnsBloc;
  var _eventBusOn;

  _refreshTxns() {
    // Restore current filter to ALL if refresh the list
    _txnsBloc.currentFilter = TxnFilter.ALL;
    Map<String, dynamic> variables = Map<String, dynamic>();
    variables['publicKey'] = _txnsBloc.publicKey;
    _txnsBloc.add(RefreshTxns(POOLED_TXNS_QUERY, variables: variables));
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

      if(event is FilterTxnsAll) {
        _txnsBloc.currentFilter = TxnFilter.ALL;
        _txnsBloc.add(ChangeFilter());
        return;
      }

      if(event is FilterTxnsSent) {
        _txnsBloc.currentFilter = TxnFilter.SENT;
        _txnsBloc.add(ChangeFilter());
        return;
      }

      if(event is FilterTxnsReceived) {
        _txnsBloc.currentFilter = TxnFilter.RECEIVED;
        _txnsBloc.add(ChangeFilter());
        return;
      }

      if(event is FilterTxnsStaked) {
        _txnsBloc.currentFilter = TxnFilter.STAKED;
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
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    print('WalletHomeScreen: didPopNext()');
  }

  @override
  void didPush() {
    super.didPush();
    print('WalletHomeScreen: didPush()');
  }

  @override
  void didPushNext() {
    final route = ModalRoute.of(context)!.settings.name;
    print('WalletHomeScreen didPushNext() route: $route');
  }

  @override
  void didPop() {
    final route = ModalRoute.of(context)!.settings.name;
    print('WalletHomeScreen didPop() route: $route');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true, splitScreenMode: false, scaleByHeight: false);
    print('TxnsScreen build(context=$context)');

    return RefreshIndicator(
      color: Colors.grey,
      onRefresh: _onRefresh,
      child: BlocBuilder<TxnsBloc, TxnsStates>(
        builder: (BuildContext context, TxnsStates state) {
          return Column(
            children: [
              _buildTxnHeader(context),
              _buildAccountSwitcher(context),
              Container(height: 6.h,),
              _buildLoadingAnimation(context, state),
              Container(height: 8.h,),
              Expanded(flex: 1, child: _buildTxnBody(context, state))
            ]
          );
        }
      )
    );
  }

  _buildTxnHeader(BuildContext context) {
    return buildTitleAppBarWithFilter(
      context,
      Text('Transaction History', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.black87),),
        () => showTxnFilterSheet(context, _txnsBloc.txnFilters, _txnsBloc.currentFilter)
    );
  }

  _buildAccountSwitcher(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
      padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xfff1f2f4), width: 0.5.w),
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
        color: Color(0xfff1f2f4),
      ),
      child: DropdownButton<AccountBean>(
        isExpanded: true,
        dropdownColor: Color(0xfff1f2f4),
        value: globalHDAccounts.accounts![_txnsBloc.accountIndex],
        icon: Image.asset('images/down_expand.png', width: 14.w, height: 14.w),
        elevation: 6,
        style: const TextStyle(color: Color(0xff2d2d2d)),
        onChanged: (AccountBean? accountBean) {
          if(accountBean!.account != _txnsBloc.accountIndex) {
            _txnsBloc.accountIndex = accountBean.account;
            _txnsBloc.mergedUserCommands.clear();
            _refreshTxns();
          }
        },
        underline: Container(),
        items: globalHDAccounts.accounts!.map<DropdownMenuItem<AccountBean>>((AccountBean? value) {
          return DropdownMenuItem<AccountBean>(
            value: value,
            child:
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('images/mina_logo_black_inner_small.png', width: 21.w, height: 21.w,),
                  Container(width: 2.w,),
                  Text(value?.accountName ?? 'null', textAlign: TextAlign.start, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
                  Expanded(
                    flex: 1,
                    child: Text('(${formatHashEllipsis(value!.address!)})', textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300, color: Color(0xff2d2d2d))),
                  )
                ],
              )
          );
        }).toList(),
      )
    );
  }

  _buildLoadingAnimation(BuildContext context, TxnsStates state) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: (state is RefreshTxnsLoading) ?
        LoadingAnimationWidget.hexagonDots(color: Colors.grey, size: 26.h) : Container()
    );
  }

  _buildTxnBody(BuildContext context, TxnsStates state) {
    if(state is RefreshTxnsLoading) {
      List<dynamic> userCommands = (state.data ?? []) as List<dynamic>;
      if(userCommands.isEmpty) {
        return Container();
      }
    }

    if(state is RefreshTxnsSuccess) {
      List<dynamic> userCommands = state.data as List<dynamic>;
      if(userCommands.isEmpty) {
        return _buildNoDataScreen(context, 'No transactions found!\n Be happy to send or receive MINA');
      }
      return _buildTxnList(context, state.data);
    }

    if(state is RefreshTxnsFail) {
      return _buildErrorScreen(context, state.error.toString());
    }

    if(state is FilterChanged) {
      List<MergedUserCommand> userCommands = state.data as List<MergedUserCommand>;
      if(userCommands.isEmpty) {
        return _buildNoDataScreen(context, 'No transactions found!!!\n Be happy to send or receive MINA');
      }
      return _buildTxnList(context, userCommands);
    }

    return _buildTxnList(context, _txnsBloc.mergedUserCommands);
  }

  _gotoTxnDetail(BuildContext context, MergedUserCommand? userCommand) {
    if(userCommand == null) {
      return;
    }

    TxnType txnType;
    if(!userCommand.isDelegation!) {
      if(userCommand.from == _txnsBloc.publicKey) {
        txnType = TxnType.SEND;
      } else {
        txnType = TxnType.RECEIVE;
      }
    } else {
      txnType = TxnType.DELEGATION;
    }

    TxnEntity txnEntity = TxnEntity(
      userCommand.from!,
      userCommand.to!,
      userCommand.dateTime,
      userCommand.amount!,
      userCommand.fee!,
      userCommand.memo!,
      userCommand.isPooled! ? TxnStatus.PENDING : TxnStatus.CONFIRMED,
      txnType,
      userCommand.isIndexerMemo!,
      userCommand.failureReason,
      userCommand.hash
    );
    Navigator.pushNamed(context, TxnDetailRoute, arguments: txnEntity);
  }
  
  _buildTxnList(BuildContext context, List<MergedUserCommand>? commands) {
    if(null == commands || commands.isEmpty) {
      return Container();
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: commands.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            InkWell(
              child: _buildTxnItem(commands[index]),
              onTap: () => _gotoTxnDetail(context, commands[index])
            ),
            Divider(height: 10.h, color: Colors.white,)
          ],
        );
      },
    );
  }

  _buildTxnItem(MergedUserCommand command) {
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 0),
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 0.5.w),
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(color: Colors.black12,
            offset: Offset(0, 0), blurRadius: 3, spreadRadius: 2.0)
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _getTxnTypeIcon(command),
          Container(width: 8.w),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${_getTxnTypeStr(command)}:', textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
                        Container(width: 2.w,),
                        Text(_getTxnRequiredAddress(command), textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w300, color: Color(0xff2d2d2d)))
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${MinaHelper.getMinaStrByNanoStr(command.amount!)}',
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: _getAmountColor(command)),),
                        Container(width: 2.w,),
                        Text('MINA', textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w300, color: _getAmountColor(command)),)
                      ],
                    ),
                  ],
                ),
                Container(height: 8.h,),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_getDateTimeStr(command), textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w300, color: _getDateTimeColor(command))),
                    Container(width: 2.w,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('fee:', textAlign: TextAlign.start, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300)),
                        Container(width: 2.w,),
                        Text('${MinaHelper.getMinaStrByNanoStr(command.fee!)}',
                          textAlign: TextAlign.start, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300, color: Color(0xff2d2d2d))),
                        Container(width: 2.w,),
                        Text('MINA', textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w300, color: Color(0xff2d2d2d)))
                      ],
                    ),
                  ],
                )
              ],)
              )
            ],
          )
    );
  }

  String _getTxnRequiredAddress(MergedUserCommand command) {
    String? requiredAddress;

    if(command.from == _txnsBloc.publicKey) {
      requiredAddress = command.to;
    }

    if(command.to == _txnsBloc.publicKey) {
      requiredAddress = command.from;
    }

    return formatHashEllipsis(requiredAddress);
  }

  Color _getDateTimeColor(MergedUserCommand command) {
    if(command.isPooled!) {
      return Color(0xff098de6);
    } else {
      return Color(0xff2d2d2d);
    }
  }

  Widget _getTxnTypeIcon(MergedUserCommand command) {
    if(null != command.failureReason) {
      return Image.asset('images/txn_wrong.png', height: 40.w, width: 40.w);
    }

    if(command.isDelegation!) {
      return Image.asset('images/txn_delegation.png', height: 40.w, width: 40.w);
    }

    if(command.from == _txnsBloc.publicKey) {
      return Image.asset('images/txn_send_blue.png', height: 40.w, width: 40.w);
    }

    if(command.to == _txnsBloc.publicKey) {
      return Image.asset('images/txn_receive_green.png', height: 40.w, width: 40.w);
    }

    return Container();
  }

  String _getTxnTypeStr(MergedUserCommand command) {
    if(command.isDelegation!) {
      if(command.from == _txnsBloc.publicKey) {
        return 'stake to';
      } else {
        return 'stake from';
      }
    }

    if(command.from == _txnsBloc.publicKey) {
      return 'to';
    }

    if(command.to == _txnsBloc.publicKey) {
      return 'from';
    }

    return '';
  }

  Color _getAmountColor(MergedUserCommand command) {
    if(command.isDelegation!) {
      return Color(0xff098de6);
    }

    if(command.from == _txnsBloc.publicKey) {
      return Color(0xff098de6);
    }

    if(command.to == _txnsBloc.publicKey) {
      return Color(0xff01c6d0);
    }

    return Colors.transparent;
  }

  String _getDateTimeStr(MergedUserCommand command) {
    if(command.isPooled!) {
      return 'pending...';
    } else {
      return DateFormat('dd/MM/yyyy, HH:mm').format(
        DateTime.fromMillisecondsSinceEpoch(int.tryParse(command.dateTime!)!));
    }
  }

  _buildErrorScreen(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(),
            child: Text(error, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 18.sp),),
          ),
          Container(height: 16.h,),
          InkWell(
            onTap: _refreshTxns,
            child: Container(
              padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 100.w, right: 100.w),
              decoration: getMinaButtonDecoration(topColor: Color(0xffeeeeee)),
              child: Text('TRY AGAIN',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
            )
          ),
        ]
      ),
    );
  }

  _buildNoDataScreen(BuildContext context, String content) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('images/txn_list_empty.png', width: 60.w, height: 60.w,),
          Container(height: 16.h,),
          Text('No Transactions', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500),),
          Container(height: 14.h,),
          Text(content, maxLines: 2,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16.sp),),
        ],
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/stake/blocs/stake_bloc.dart';
import 'package:coda_wallet/stake/blocs/stake_events.dart';
import 'package:coda_wallet/stake/blocs/stake_states.dart';
import 'package:coda_wallet/stake/query/get_consensus_state.dart';
import 'package:coda_wallet/widget/account/account_list.dart';
import 'package:coda_wallet/widget/dialog/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StakeScreen extends StatefulWidget {
  StakeScreen({Key key}) : super(key: key);

  @override
  _StakeScreenState createState() => _StakeScreenState();
}

class _StakeScreenState extends State<StakeScreen> with AutomaticKeepAliveClientMixin {
  bool _stakeEnabled = true;
  StakeBloc _stakeBloc;

  @override
  void initState() {
    super.initState();
    _stakeBloc = BlocProvider.of<StakeBloc>(context);
    _stakeBloc.add(GetConsensusState(CONSENSUS_STATE_QUERY));
  }

  @override
  void dispose() {
    _stakeBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('StakeScreen build()');
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    return _buildWalletHomeBody();
  }

  Widget _buildWalletHomeBody() {
    if(_stakeEnabled) {
      return _buildStakedHome();
    }

    return _buildNoStakeHome();
  }

  _buildStakedHome() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(children: [
          Container(height: 52.h),
          Text('You Are Staking!', textAlign: TextAlign.center, style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.normal, color: Colors.black)),
          Container(height: 41.h),
          Padding(
            padding: EdgeInsets.only(left: 13.w, right: 13.w),
            child: BlocBuilder<StakeBloc, StakeStates>(
              builder: (BuildContext context, StakeStates state) {
                int epoch = 0;
                int slot = 0;
                if(state is GetConsensusStateFailed) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ProgressDialog.dismiss(context);
                    String error = state.data;
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text(error)));
                  });
                }

                if(state is GetConsensusStateLoading) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ProgressDialog.showProgress(context);
                  });
                }

                if(state is GetConsensusStateSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ProgressDialog.dismiss(context);
                  });
                  epoch = state?.epoch ?? 0;
                  slot = state?.slot ?? 0;
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text('Epoch: $epoch', textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Progress: ', textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),),
                        Container(width: 4.w,),
                        SizedBox(width: 120.w, height: 20.h,
                          child: LinearProgressIndicator(
                            value: slot / SLOT_PER_EPOCH,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation(Colors.redAccent),),
                        )
                      ],
                    )
                  ],
                );
              }
            )
          ),
          Container(height: 14.h),
          Expanded(
            child: buildAccountList((index) {
              Navigator.of(context).pushNamed(StakeProviderRoute, arguments: index);
            })
          )
        ]),
      ],
    );
  }

  _buildNoStakeHome() {
    return Container();
  }

  @override
  bool get wantKeepAlive => false;
}
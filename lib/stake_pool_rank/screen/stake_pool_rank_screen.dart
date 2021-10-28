import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/stake_pool_rank/blocs/block_produced_entity.dart';
import 'package:coda_wallet/stake_pool_rank/blocs/stake_pool_rank_bloc.dart';
import 'package:coda_wallet/stake_pool_rank/blocs/stake_pool_rank_events.dart';
import 'package:coda_wallet/stake_pool_rank/blocs/stake_pool_rank_states.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:coda_wallet/widget/ui/pool_performance_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StakePoolRankScreen extends StatefulWidget {
  StakePoolRankScreen({Key? key}) : super(key: key);

  @override
  _StakePoolRankScreenState createState() => _StakePoolRankScreenState();
}

class _StakePoolRankScreenState extends State<StakePoolRankScreen> {

  late var _stakePoolRankBloc;
  late Map<String, dynamic> _params;

  @override
  void initState() {
    super.initState();
    _stakePoolRankBloc = BlocProvider.of<StakePoolRankBloc>(context);
    // _stakePoolRankBloc.creator = 'B62qpge4uMq4Vv5Rvc8Gw9qSquUYd6xoW1pz7HQkMSHm6h1o7pvLPAN';
    // _stakePoolRankBloc.add(GetPoolBlocks());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: Size(375, 812),
      orientation: Orientation.portrait
    );
    _params = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _stakePoolRankBloc.creator = _params['validatorAddress'];
    _stakePoolRankBloc.add(GetPoolBlocks());
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: buildNoTitleAppBar(context, actions: false),
        body: SafeArea(
          child: Container(
          decoration: BoxDecoration(
            color: Color(0xffb5b18c),
          ),
          child: BlocBuilder<StakePoolRankBloc, StakePoolRankStates>(
            builder: (BuildContext context, StakePoolRankStates state) {
              if (state is GetPoolBlocksSuccess) {
                return _buildPoolRankWidget(context, state.canonicalBlocks, state.orphanBlocks);
              }
              return Container();
            }
          )
        )
      )
    );
  }

  _buildPoolRankWidget(BuildContext context, List<EpochBlocks> canonicalBlocks, List<EpochBlocks> orphanBlocks) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('${_params['validatorName']}'),
        Container(height: 20.h,),
        Text('Pool Performance'),
        Container(height: 2.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width: 12.w, height: 12.w, color: Colors.green,),
            Text(' Canonical '),
            Container(width: 12.w, height: 12.w, color: Colors.red,),
            Text(' Orphan')
          ],
        ),
        Container(height: 8.h,),
        SizedBox(width: 280.w, height: 360.h, child: PoolPerformanceChart.withSampleData(canonicalBlocks, orphanBlocks)),
        Container(height: 4.h,),
        Text('Pool Rank'),
        Container(height: 4.h,),
        RatingBar.builder(
          initialRating: 3.5,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 24.w,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0.w),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        )
      ],
    );
  }
}

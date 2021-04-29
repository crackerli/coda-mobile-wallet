import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_bloc.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_entity.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_events.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_states.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/dialog/loading_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StakeProviderScreen extends StatefulWidget {
  StakeProviderScreen({Key key}) : super(key: key);

  @override
  _StakeProviderScreenState createState() => _StakeProviderScreenState();
}

class _StakeProviderScreenState extends State<StakeProviderScreen> {

 // List<Staking_providersBean> _providerList;
  StakeProvidersBloc _stakeProvidersBloc;

  @override
  void initState() {
    super.initState();
    // String providerString = globalPreferences.getString(STAKETAB_PROVIDER_KEY);
    // Map<String, dynamic> providerMap;
    // if(null != providerString && providerString.isNotEmpty) {
    //   providerMap = json.decode(providerString);
    // }
    //
    // // Convert provider map to provider list
    // if(null != providerMap) {
    //   _providerList =
    //     providerMap.entries.map((entry) => Staking_providersBean.fromMap(entry.value)).toList();
    // }

    _stakeProvidersBloc = BlocProvider.of<StakeProvidersBloc>(context);
    _stakeProvidersBloc.add(GetStakeProviders());
  }

  @override
  void dispose() {
    _stakeProvidersBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: buildNoTitleAppBar(context, actions: false),
        body: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: _buildProviderBody(context),
        decoration: BoxDecoration(
          color: Colors.white
        ),
      )
    );
  }

  _buildProviderBody(BuildContext context) {
    return Column(
      children: [
        Text('Select A Staking Provider', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500),),
        Container(height: 22.h,),
        _buildProviderTab(context),
        Container(height: 14.h),
        Container(height: 0.5.h, color: Color(0xff757575),),
        Expanded(
          child: BlocBuilder<StakeProvidersBloc, StakeProvidersStates>(
            builder: (BuildContext context, StakeProvidersStates state) {
              return _buildProviderList(context, state);
            }
          )
        )
      ],
    );
  }

  _buildProviderTab(BuildContext context) {
    return Row(
      children: [
        Container(width: 40.w,),
        Container(width: 10.w,),
        Expanded(
          flex: 5,
          child: Text('Validator', textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),),
        ),
        Container(width: 2.w,),
        Expanded(
          flex: 3,
          child: Text('Stake', textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),),
        ),
        Container(width: 2.w,),
        Expanded(
          flex: 2,
          child: Text('Fee', textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),),
        ),
        Container(width: 1.w,),
        Expanded(
          flex: 3,
          child: Text('Terms', textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),),
        ),
      ],
    );
  }

  _buildProviderList(BuildContext context, StakeProvidersStates state) {
    if(state is GetStakeProvidersLoading) {
      print('adfadfadfdsfdsafdsafsdfasdf');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ProgressDialog.showProgress(context);
      });
      return Container();
    }

    if(state is GetStakeProvidersFail) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ProgressDialog.dismiss(context);
      });
      // Return error page
      return Container();
    }

    if(state is GetStakeProvidersSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ProgressDialog.dismiss(context);
      });

      List<Staking_providersBean> providers = (state as GetStakeProvidersSuccess).data as List<Staking_providersBean>;
      if(null == providers || providers.length == 0) {
        return Container();
      }

      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: null == providers ? 0 : providers.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: _buildProviderItem(context, providers[index]),
            onTap: () => {

            });
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
  }

  _buildProviderItem(BuildContext context, Staking_providersBean provider) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
        CachedNetworkImage(
          maxHeightDiskCache: 200,
          imageUrl: provider?.providerLogo ?? '',
          width: 40.w,
          height: 40.h,
          placeholder: (context, url) => Image.asset('images/txn_stake.png', width: 40.w, height: 40.h,),
          errorWidget: (context, url, error) => Image.asset('images/txn_stake.png', width: 40.w, height: 40.h,),
        ),
        Container(width: 10.w,),
        Expanded(
          flex: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${provider.providerTitle ?? ''}', textAlign: TextAlign.left, maxLines: 1,
                overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
              Container(height: 3.h,),
              Text('${formatHashEllipsis(provider.providerAddress ?? '')}', textAlign: TextAlign.left, maxLines: 1,
                  overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Container(width: 2.w,),
        Expanded(
          flex: 3,
          child:
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${provider.stakedSum.floor().toString()}', textAlign: TextAlign.right, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),),
                Container(height: 3.h,),
                Text('${provider.stakePercent.toString()}%', textAlign: TextAlign.right, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),),
              ],
            ),
        ),
        Container(width: 2.w,),
        Expanded(
          flex: 2,
          child: Container(
          padding: EdgeInsets.only(left: 3.w),
            child: Center(
              child: Text('${provider.providerFee}%', textAlign: TextAlign.end, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),),
            )
          )
        ),
        Container(width: 1.w,),
        Expanded(
          flex: 3,
          child: Text('${provider.payoutTerms}', textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400))
        ),
      ],
    ));
  }
}
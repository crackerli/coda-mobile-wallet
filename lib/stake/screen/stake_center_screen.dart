import 'package:cached_network_image/cached_network_image.dart';
import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/stake/blocs/stake_center_states.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_entity.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_countdown_timer/index.dart';
import '../../global/global.dart';
import '../../types/mina_hd_account_type.dart';
import '../../util/format_utils.dart';
import '../../widget/app_bar/app_bar.dart';
import '../blocs/stake_center_bloc.dart';
import '../blocs/stake_center_events.dart';
import '../blocs/stake_state_entity.dart';

const FLEX_LEFT_LABEL = 3;
const FLEX_RIGHT_CONTENT = 10;
const CONTENT_DIVIDER_HEIGHT = 10;

class StakeCenterScreen extends StatefulWidget {
  StakeCenterScreen({Key? key}) : super(key: key);

  @override
  _StakeCenterScreenState createState() => _StakeCenterScreenState();
}


class _StakeCenterScreenState extends State<StakeCenterScreen> with AutomaticKeepAliveClientMixin {
  StakeCenterBloc? _stakeCenterBloc;

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _stakeCenterBloc = BlocProvider.of<StakeCenterBloc>(context);
    _stakeCenterBloc!.add(GetStakeStatusEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _stakeCenterBloc = null;
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _stakeCenterBloc!.add(GetStakeStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.init(context, designSize: const Size(375, 812),
      minTextAdapt: true, splitScreenMode: false, scaleByHeight: false);

    return RefreshIndicator(
      color: Colors.grey,
      onRefresh: _onRefresh,
      child: Column(
        children: [
          buildPureTextTitleAppBar(context, 'Stake Center'),
          BlocBuilder<StakeCenterBloc, StakeCenterStates>(
            builder: (BuildContext context, StakeCenterStates state) {
              return _buildAccountSwitcher(context);
            }
          ),
          Container(height: 4.h),
          BlocBuilder<StakeCenterBloc, StakeCenterStates>(
            builder: (BuildContext context, StakeCenterStates state) {
              return _buildLoadingAnimation(context, state);
            }
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(height: 16.h),
                  BlocBuilder<StakeCenterBloc, StakeCenterStates>(
                    builder: (BuildContext context, StakeCenterStates state) {
                      return _buildEpochStatus(context);
                    }
                  ),
                  _buildStakingBody(context),
                  Container(height: 20.h,),
                  Container(
                    margin: EdgeInsets.only(left: 22.w, right: 22.w),
                    child: Text('Tips: ' +
                      'Better delegate one day before current epoch ends, otherwise you need wait three epochs.',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d), fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            )
          ),
          BlocBuilder<StakeCenterBloc, StakeCenterStates>(
            builder: (BuildContext context, StakeCenterStates state) {
              return _buildStakingButton(context, state);
          })
        ],
      )
    );
  }

  _buildStakingBody(BuildContext context) {
    return BlocBuilder<StakeCenterBloc, StakeCenterStates>(
      builder: (BuildContext context, StakeCenterStates state) {
        if(state is GetStakeStatusLoading) {
          return Container();
        }

        if(state is GetStakeStatusFailed) {
          return _buildErrorWidget(context, state);
        }

        if(!_stakeCenterBloc!.accountActive) {
          return _buildNotActive(context);
        } else if(!_stakeCenterBloc!.isAccountStaking()) {
          return _buildNotStaked(context);
        } else {
          return Column(
            children: [
              _stakeCenterBloc!.isAccountStaking() ? Container(height: 20.h,) : Container(),
              _buildStakingPager(context),
              _stakeCenterBloc!.isAccountStaking() ? Container(height: 20.h,) : Container(),
              _buildLastStakedPool(context)
            ],
          );
        }
      }
    );
  }

  _buildLoadingAnimation(BuildContext context, StakeCenterStates state) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: (state is GetStakeStatusLoading) ?
        LoadingAnimationWidget.hexagonDots(color: Colors.grey, size: 26.h) : Container()
    );
  }

  _buildEpochStatus(BuildContext context) {
    double epochProgress = _stakeCenterBloc!.slot / SLOT_PER_EPOCH;

    return Container(
      margin: EdgeInsets.fromLTRB(18.w, 0, 18.w, 0),
      padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0.h),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 46.w,
                lineWidth: 5.0,
                percent: epochProgress,
                animation: true,
                backgroundColor: Color(0xffbac3df),
                center: Text('${(epochProgress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 14.sp, color: Colors.black, fontWeight: FontWeight.w600)),
                progressColor: Color(0xff098de6),
              ),
              Container(width: 40.w,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Current epoch:', textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Color(0xff979797)),),
                      Container(width: 6.w,),
                      Text('${_stakeCenterBloc!.epoch}', textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff373737)),),
                    ],
                  ),
                  Container(height: CONTENT_DIVIDER_HEIGHT.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Ends in:', textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Color(0xff979797)),),
                      Container(width: 6.w,),
                      _buildTimer(context),
                    ],
                  )
                ],
              )
            ],
          )
        ]
      )
    );
  }

  _buildTimerCounter(BuildContext context, int? time) {
    return Container(
      padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
      width: 24.w,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xfff0f0f0), width: 0.5.w),
        borderRadius: BorderRadius.all(Radius.circular(2.w)),
        color: Color(0xffe0e0e0),
      ),
      child: Text('${_formatCountNumber(time)}', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff373737)),),
    );
  }

  _buildTimer(BuildContext context) {
    return CountdownTimer(
      endTime: _stakeCenterBloc!.counterEndTime,
      widgetBuilder: (_, CurrentRemainingTime? time) {
        if(null == time) {
          _stakeCenterBloc!.add(TimerEndEvent());
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTimerCounter(context, time?.days),
            Container(width: 2.w,),
            Text('d', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff373737)),),
            Container(width: 2.w,),
            _buildTimerCounter(context, time?.hours),
            Container(width: 2.w,),
            Text(':', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff373737))),
            Container(width: 2.w,),
            _buildTimerCounter(context, time?.min),
            Container(width: 2.w,),
            Text(':', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff373737))),
            Container(width: 2.w,),
            _buildTimerCounter(context, time?.sec),
          ],
        );
      },
    );
  }

  _buildPartialDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: FLEX_LEFT_LABEL,
          child: Container(),
        ),
        Expanded(
          flex: FLEX_RIGHT_CONTENT,
          child: Container(height: 1.h, color: Color(0xffeeeef0),),
        )
      ],
    );
  }

  _buildStakingDetails(BuildContext context, StakeStateEntity stakeState, {bool withCommand = false}) {
    String stakingTitle = '';
    String pagerCommandTitle = '';

    if(stakeState.isCurrent) {
      stakingTitle = 'Current epoch staking';
      pagerCommandTitle = 'NEXT';
    } else {
      stakingTitle = 'Next epoch staking';
      pagerCommandTitle = 'PREVIOUS';
    }

    return Container(
      margin: EdgeInsets.fromLTRB(18.w, 2.h, 18.w, 2.h),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 0.5.w),
        borderRadius: BorderRadius.all(Radius.circular(7.w)),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(color: Color(0xfff0f0f0),
            offset: Offset(0, 0), blurRadius: 2, spreadRadius: 2.0)
        ]
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: withCommand ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(stakingTitle, textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
              withCommand ?
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  stakeState.isCurrent ? Container() : Image.asset('images/left_arrow_triangle.png', width: 13.w, height: 13.h,),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
                      backgroundColor: Colors.white24,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
                      side: BorderSide(width: 1.w, color: Color(0xff098de6))
                    ),
                    onPressed: () {
                      if(stakeState.isCurrent) {
                        _pageController.animateToPage(1, duration: Duration(microseconds: 500), curve: Curves.linear);
                      } else {
                        _pageController.animateToPage(0, duration: Duration(microseconds: 500), curve: Curves.linear);
                      }
                    },
                    child: Text(pagerCommandTitle, textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w300, color: Color(0xff098de6)))),
                  stakeState.isCurrent ? Image.asset('images/right_arrow_triangle.png', width: 13.w, height: 13.h,) : Container(),
                ],
              ) : Container()
            ],
          ),
          Container(height: CONTENT_DIVIDER_HEIGHT.h),
          Container(height: 1.h, color: Color(0xffeeeef0),),
          Container(height: CONTENT_DIVIDER_HEIGHT.h),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: FLEX_LEFT_LABEL,
                    child: Text('Staking on', textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300, color: Color(0xff979797)),),
                  ),
                  Expanded(
                    flex: FLEX_RIGHT_CONTENT,
                    child: Text(stakeState.providerName, textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
                  )
                ],
              ),
              Container(height: CONTENT_DIVIDER_HEIGHT.h,),
              _buildPartialDivider(context),
              Container(height: CONTENT_DIVIDER_HEIGHT.h,),
              Row(
                children: [
                  Expanded(
                    flex: FLEX_LEFT_LABEL,
                    child: Container(),
                  ),
                  Expanded(
                    flex: FLEX_RIGHT_CONTENT,
                    child: Text('${formatHashEllipsis(stakeState.poolAddress, short: false)}', textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
                  )
                ],
              )
            ],
          ),
          Container(height: CONTENT_DIVIDER_HEIGHT.h),
          Container(height: 1.h, color: Color(0xffeeeef0),),
          Container(height: CONTENT_DIVIDER_HEIGHT.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(stakeState.stakeAmount, textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
                  Container(height: 6.h,),
                  Text('Staked balance', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff979797)),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(stakeState.fee, textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
                  Container(height: 6.h,),
                  Text('Pool fee', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff979797)),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(stakeState.idealApy, textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff6bc7a1)),),
                  Container(height: 6.h,),
                  Text('Ideal APY', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff979797)),),
                ],
              )
            ],
          ),
        ],
      )
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
        value: globalHDAccounts.accounts![_stakeCenterBloc!.accountIndex],
        icon: Image.asset('images/down_expand.png', width: 14.w, height: 14.w),
        elevation: 6,
        style: const TextStyle(color: Color(0xff2d2d2d)),
        onChanged: (AccountBean? accountBean) {
          if(accountBean!.account != _stakeCenterBloc!.accountIndex) {
            _stakeCenterBloc!.accountIndex = accountBean.account!;
            _stakeCenterBloc!.add(GetStakeStatusEvent());
          }
        },
        underline: Container(),
        items: globalHDAccounts.accounts!.map<DropdownMenuItem<AccountBean>>((AccountBean? value) {
          return DropdownMenuItem<AccountBean>(
            value: value,
            child: Row(
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
            ));
          }).toList(),
        )
    );
  }

  _buildStakingPager(BuildContext context) {
    if(_stakeCenterBloc!.isAccountStaking()) {
      if(_stakeCenterBloc!.stakingStates.isEmpty) {
        return Text('Wait for staking become available');
      } else {
        return Row(
          children: [
            _buildStakingEpochs(context),
          ]
        );
      }
    } else {
      return Container();
    }
  }

  _buildStakingEpochs(BuildContext context) {

    if(1 == _stakeCenterBloc!.stakingStates.length) {
      return Expanded(
        child: ExpandablePageView(
          children: <Widget>[
            _buildStakingDetails(context, _stakeCenterBloc!.stakingStates[0], withCommand: false),
          ],
        )
      );
    } else if(2 == _stakeCenterBloc!.stakingStates.length) {
      return Expanded(
        child: ExpandablePageView(
          controller: _pageController,
          children: <Widget>[
            _buildStakingDetails(context, _stakeCenterBloc!.stakingStates[0], withCommand: true),
            _buildStakingDetails(context, _stakeCenterBloc!.stakingStates[1], withCommand: true)
          ],
        )
      );
    } else {
      // Should not happen though
      return Container();
    }
  }

  _buildLastStakedPool(BuildContext context) {
    if(null == _stakeCenterBloc!.stakingProvider) {
      return Container();
    }

    Staking_providersBean stakingProvider = _stakeCenterBloc!.stakingProvider!;
    bool hidePoolSite = (null == stakingProvider.website || stakingProvider.website!.isEmpty);
    bool hidePayoutTerms = (null == stakingProvider.payoutTerms || stakingProvider.payoutTerms!.isEmpty);
    bool hideContacts = _getContacts(stakingProvider).isEmpty;

    return Container(
      margin: EdgeInsets.fromLTRB(18.w, 0, 18.w, 0),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 0.5.w),
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(color: Color(0xfff0f0f0),
            offset: Offset(0, 0), blurRadius: 2, spreadRadius: 2.0)
        ]
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Stake pool delegated', textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),)
            ],
          ),
          Container(height: CONTENT_DIVIDER_HEIGHT.h),
          Container(height: 1.h, color: Color(0xffeeeef0),),
          Container(height: CONTENT_DIVIDER_HEIGHT.h),
          Row(
            children: [
              CachedNetworkImage(
                maxHeightDiskCache: 200,
                imageUrl: stakingProvider.providerLogo ?? '',
                width: 40.w,
                height: 40.w,
                placeholder: (context, url) => Image.asset('images/txn_delegation.png', width: 40.w, height: 40.w,),
                errorWidget: (context, url, error) => Image.asset('images/txn_delegation.png', width: 40.w, height: 40.w,),
              ),
              Container(width: 6.w,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stakingProvider.providerTitle ?? 'Unknown',
                    textAlign: TextAlign.start, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff098de6)),),
                  Container(height: 6.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${formatHashEllipsis(stakingProvider.providerAddress, short: false)}', textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 14.sp, color: Color(0xff2d2d2d)),),
                      Container(width: 3.w,),
                      stakingProvider.addressVerification == 1 ?
                      Image.asset('images/verified.png', width: 12.w, height: 12.w,) : Container()
                    ],
                  )
                ],
              )
            ],
          ),
          Container(height: CONTENT_DIVIDER_HEIGHT.h),
          Container(height: 1.h, color: Color(0xffeeeef0),),
          Container(height: CONTENT_DIVIDER_HEIGHT.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formatKMBNumber(stakingProvider.stakedSum!), textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
                  Container(height: CONTENT_DIVIDER_HEIGHT.h,),
                  Text('Pool size', textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Color(0xff979797)),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${stakingProvider.stakePercent}%', textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
                  Container(height: CONTENT_DIVIDER_HEIGHT.h,),
                  Text('Percent', textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Color(0xff979797)),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${stakingProvider.providerFee}%', textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
                  Container(height: CONTENT_DIVIDER_HEIGHT.h,),
                  Text('Fee', textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Color(0xff979797)),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formatKMBNumber(stakingProvider.delegatorsNum!.toDouble()), textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
                  Container(height: CONTENT_DIVIDER_HEIGHT.h,),
                  Text('Delegators', textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Color(0xff979797)),),
                ],
              ),
            ],
          ),
          hidePoolSite ? Container() : Container(height: CONTENT_DIVIDER_HEIGHT.h),
          hidePoolSite ? Container() : Container(height: 1.h, color: Color(0xffeeeef0),),
          hidePoolSite ? Container() : Container(height: CONTENT_DIVIDER_HEIGHT.h),
          hidePoolSite ? Container() :
          Row(
            children: [
              Text('Pool site:', textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300, color: Color(0xff979797)),),
              Container(width: 4.w,),
              Expanded(
                child: Text(stakingProvider.website ?? '', textAlign: TextAlign.start, maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Color(0xff098de6)),),
              ),
            ],
          ),
          hidePayoutTerms ? Container() : Container(height: CONTENT_DIVIDER_HEIGHT.h),
          hidePayoutTerms ? Container() : Container(height: 1.h, color: Color(0xffeeeef0),),
          hidePayoutTerms ? Container() : Container(height: CONTENT_DIVIDER_HEIGHT.h),
          hidePayoutTerms ? Container() : _buildPayoutTerms(context, stakingProvider.payoutTerms),
          hideContacts ? Container() : Container(height: CONTENT_DIVIDER_HEIGHT.h),
          hideContacts ? Container() : Container(height: 1.h, color: Color(0xffeeeef0),),
          hideContacts ? Container() : Container(height: CONTENT_DIVIDER_HEIGHT.h),
          hideContacts ? Container() : _buildContacts(context, stakingProvider),
          Container(height: CONTENT_DIVIDER_HEIGHT.h,),
          Container(
            width: 260.w,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
                foregroundColor: Color(0xff098de6),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
                side: BorderSide(width: 1.w, color: Color(0xff098de6))
              ),
              onPressed: () {

              },
              child: Text('DETAILS', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff098de6)))
            )
          )
        ],
      ),
    );
  }

  _buildStakingButton(BuildContext context, StakeCenterStates state) {
    void Function()? onPressed;
    String commandString = 'DELEGATE';
    Color commandColor = Color(0xff098de6);

    if((state is GetStakeStatusLoading) || !_stakeCenterBloc!.accountActive) {
      onPressed = null;
      commandColor = Color(0xff979797);
    } else {
      onPressed = () {
        _stakeCenterBloc!.add(GetStakeStatusEvent());
      };
      commandColor = Color(0xff098de6);
    }

    if(_stakeCenterBloc!.isAccountStaking()) {
      commandString = 'CHANGE POOL';
    } else {
      commandString = 'DELEGATE';
    }

    return Container(
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
      width: MediaQuery.of(context).size.width,
      color: Color(0xfff9f9f9),
      child: Center(
        child: Container(
          width: 300.w,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
              foregroundColor: Color(0xff098de6),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
              side: BorderSide(width: 1.w, color: commandColor)
            ),
            onPressed: onPressed,
            child: Text(commandString, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: commandColor))
          )
        )
      )
    );
  }

  _buildErrorWidget(BuildContext context, GetStakeStatusFailed state) {
    return Center(
      child: Column(
        children: [
          Container(height: 60.h,),
          Padding(
            padding: EdgeInsets.only(left: 26.w, right: 26.w),
            child: Text(state.error, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d)),)
          ),
          Container(height: 8.h,),
          Container(
            width: 260.w,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
                foregroundColor: Color(0xff098de6),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
                side: BorderSide(width: 1.w, color: Color(0xff098de6))
              ),
              onPressed: () {
                _stakeCenterBloc!.add(GetStakeStatusEvent());
              },
              child: Text('RETRY', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Color(0xff098de6)))
            )
          )
        ],
      )
    );
  }

  _buildNotActive(BuildContext context) {
    return Column(
      children: [
        Container(height: 40.h,),
        Image.asset('images/account_not_active.png', width: 86.w, height: 80.w,),
        Container(height: 2.h,),
        Text('Inactive account', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Color(0xfffe5962)),),
        Container(height: 4.h,),
        Padding(
          padding: EdgeInsets.only(left: 26.w, right: 26.w),
          child: Text('Send more than one MINA to this address to activate this account', textAlign: TextAlign.start,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d)),)
        ),
      ],
    );
  }

  _buildNotStaked(BuildContext context) {
    return Column(
      children: [
        Container(height: 40.h,),
        Image.asset('images/not_staked.png', width: 80.w, height: 80.w,),
        Container(height: 6.h,),
        Text('Account not staked', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Color(0xff979797)),),
        Container(height: 6.h,),
        Padding(
          padding: EdgeInsets.only(left: 26.w, right: 26.w),
          child: Text('Delegate your MINA tokens to a staking provider, and earn more MINA.\n\n'+
            'Staked tokens stay under your control, and can be transferred at anytime.', textAlign: TextAlign.start,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d)),)
        ),
      ],
    );
  }

  _buildPayoutTerms(BuildContext context, String? termSrc) {
    if(null == termSrc || termSrc.isEmpty || termSrc.trim().isEmpty) {
      return Container();
    }

    List<String> terms = termSrc.split(',');
    List<Widget> termWidgets = [];
    termWidgets.add(
      Text('Payout terms:', textAlign: TextAlign.start,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300, color: Color(0xff979797))),
    );
    termWidgets.add(Container(width: 4.w,));

    terms.forEach((element) {
      termWidgets.add(Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffd0d0d0), width: 0.5.w),
          borderRadius: BorderRadius.all(Radius.circular(2.w)),
          color: Colors.white24,
        ),
        child: Text(element.trim(), textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d)),),
      ));
      termWidgets.add(Container(width: 3.w,));
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: termWidgets,
    );
  }

  _buildContacts(BuildContext context, Staking_providersBean? stakingProvider) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Contacts:', textAlign: TextAlign.start,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300, color: Color(0xff979797)),),
        Container(width: 4.w,),
        (stakingProvider?.discordUsername ?? '').isNotEmpty ?
        Builder(builder: (context) =>
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: stakingProvider?.discordUsername ?? ''));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Discord user name copied into clipboard!!')));
            },
            child: Image.asset('images/discord.png', height: 26.h, width: 26.w,)
          )
        ) : Container(),
        (stakingProvider?.telegram ?? '').isNotEmpty ?
        Builder(builder: (context) =>
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: stakingProvider?.telegram ?? ''));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Telegram handle copied into clipboard!!')));
            },
            child: Image.asset('images/telegram.png', height: 26.h, width: 26.w,)
          )
        ) : Container(),
        (stakingProvider?.twitter ?? '').isNotEmpty ?
        Builder(builder: (context) =>
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: stakingProvider?.twitter ?? ''));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Twitter account copied into clipboard!!')));
            },
            child: Image.asset('images/twitter.png', height: 26.h, width: 26.w,)
          )
        ) : Container(),
        (stakingProvider?.email ?? '').isNotEmpty ?
        Builder(builder: (context) =>
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: stakingProvider?.email ?? ''));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email copied into clipboard!!')));
            },
            child: Image.asset('images/mail.png', height: 26.h, width: 26.w,)
          )
        ) : Container(),
      ],
    );
  }

  List<String> _getContacts(Staking_providersBean? stakingProvider) {
    List<String> contacts = [];
    if(null == stakingProvider) {
      return contacts;
    }

    if(null != stakingProvider.discordUsername && stakingProvider.discordUsername!.isNotEmpty) {
      contacts.add(stakingProvider.discordUsername!);
    }

    if(null != stakingProvider.telegram && stakingProvider.telegram!.isNotEmpty) {
      contacts.add(stakingProvider.telegram!);
    }

    if(null != stakingProvider.twitter && stakingProvider.twitter!.isNotEmpty) {
      contacts.add(stakingProvider.twitter!);
    }

    if(null != stakingProvider.email && stakingProvider.email!.isNotEmpty) {
      contacts.add(stakingProvider.email!);
    }

    return contacts;
  }

  String _formatCountNumber(int? number) {
    if(null == number) {
      return '00';
    } else {
      if(number < 10) {
        return '0$number';
      } else {
        return number.toString();
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
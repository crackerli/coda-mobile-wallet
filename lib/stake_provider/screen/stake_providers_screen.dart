import 'package:cached_network_image/cached_network_image.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_bloc.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_entity.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_events.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_states.dart';
import 'package:coda_wallet/types/send_data.dart';
import 'package:coda_wallet/util/format_utils.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/dialog/loading_dialog.dart';
import 'package:coda_wallet/widget/dialog/url_open_warning_dialog.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/stake_provider_type.dart';

_gotoDelegationFee(BuildContext context, SendData delegationData) {
  Navigator.pushReplacementNamed(context, SendFeeRoute, arguments: delegationData);
}

// Some providers name has non-ascii code, need to remove them
// And need to limited the length of generated memo to less than 31
_getValidMemo(String? providerName) {
  if(null == providerName || providerName.isEmpty) {
    return 'Delegate to unknown';
  }

  String validName = providerName.replaceAll('[^\\x00-\\x7F]', '');
  String memo = 'Delegate to $validName';
  if(memo.length > 30) {
    return memo.substring(0, 30);
  }

  return memo;
}

class StakeProviderScreen extends StatefulWidget {
  StakeProviderScreen({Key? key}) : super(key: key);

  @override
  _StakeProviderScreenState createState() => _StakeProviderScreenState();
}

class _StakeProviderScreenState extends State<StakeProviderScreen> {

  late var _stakeProvidersBloc;
  late int _accountIndex;

  FocusNode _focusNodeProviders = FocusNode();
  TextEditingController _controllerProviders = TextEditingController();

  _getStakeProviders() {
    _stakeProvidersBloc.add(GetStakeProviders());
  }

  @override
  void initState() {
    super.initState();
    _stakeProvidersBloc = BlocProvider.of<StakeProvidersBloc>(context);
    _getStakeProviders();
  }

  @override
  void dispose() {
    _stakeProvidersBloc = null;
    _focusNodeProviders.dispose();
    _controllerProviders.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true, splitScreenMode: false, scaleByHeight: false);
    _accountIndex = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: buildTitleAppBar(context, 'Staking Providers', actions: false),
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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(height: 12.h,),
        BlocBuilder<StakeProvidersBloc, StakeProvidersStates>(
          builder: (BuildContext context, StakeProvidersStates state) {
            return _buildSearchWidget(context);
          },
        ),
        Container(height: 8.h,),
        Row(
          children: [
            Container(width: 6.w,),
            Text('Sort by:', textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w300, color: Color(0xff2d2d2d)),),
            Expanded(child: Container(), flex: 1,)
          ],
        ),
        Container(height: 6.h,),
        BlocBuilder<StakeProvidersBloc, StakeProvidersStates>(
          builder: (BuildContext context, StakeProvidersStates state) {
            if(state is SortedProvidersStates) {
              return _buildSortWidget(context, state);
            }
            else {
              return _buildSortWidget(context,
                SortedProvidersStates(_stakeProvidersBloc.currentSortManner));
            }
          }
        ),
        Container(height: 14.h,),
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


  _buildSearchWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(6.w, 0, 6.w, 0),
      padding: EdgeInsets.fromLTRB(8.w, 4.h, 0, 4.h),
      decoration: BoxDecoration(
      border: Border.all(color: Color(0xfff1f2f4), width: 0.5.w),
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
        color: Color(0xfff1f2f4),
      ),
      child: Row(
        children: [
          Expanded(child:
            TextField(
              enabled: _stakeProvidersBloc.searchBarEnabled,
              enableInteractiveSelection: true,
              focusNode: _focusNodeProviders,
              controller: _controllerProviders,
              onChanged: (text) {
                if(_controllerProviders.text.isEmpty) {
                  _stakeProvidersBloc.add(ProviderSearchEvent(false, _controllerProviders.text));
                }
              },
              maxLines: 1,
              obscureText: false,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: InputDecoration.collapsed(
                hintText: 'Search By Name, e.g Everstake',
                hintStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal, color: Color(0xffbdbdbd)))
              ),
          ),
          InkWell(
            onTap: _stakeProvidersBloc.searchBarEnabled ?
              () {
                if(_controllerProviders.text.isNotEmpty) {
                  _stakeProvidersBloc.add(ProviderSearchEvent(true, _controllerProviders.text));
                }
              } : null,
            child: Container(
              padding: EdgeInsets.fromLTRB(12.w, 4.h, 4.w, 4.h),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xfff1f2f4), width: 0.5.w),
                borderRadius: BorderRadius.all(Radius.circular(5.w)),
                color: Color(0xfff1f2f4),
              ),
              child: Center(
                child: Image.asset('images/icon_search.png', width: 26.w, height: 26.w,),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildSortWidget(BuildContext context, SortedProvidersStates state) {
    return Container(
      margin: EdgeInsets.fromLTRB(6.w, 0, 6.w, 0),
      padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 0),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xfff1f2f4), width: 0.5.w),
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
        color: Color(0xfff1f2f4),
      ),
      child:
        DropdownButton<SortProvidersManner>(
          isExpanded: true,
          dropdownColor: Color(0xfff1f2f4),
          value: state.manner,
          icon: Image.asset('images/down_expand.png', width: 14.w, height: 14.w),
          elevation: 6,
          style: const TextStyle(color: Color(0xff2d2d2d)),
          onChanged: _stakeProvidersBloc.dropDownMenuEnabled ? (SortProvidersManner? value) {
            if(_stakeProvidersBloc.currentSortManner != value) {
              _stakeProvidersBloc.add(SortProvidersEvents(value!));
            }
          } : null,
          underline: Container(),
          items: _stakeProvidersBloc.sortManners.map<DropdownMenuItem<SortProvidersManner>>((SortProvidersManner value) {
            return DropdownMenuItem<SortProvidersManner>(
              value: value,
              child: Text(_stakeProvidersBloc.sortMannerNames[value.index], textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Color(0xff2d2d2d)),),
            );
          }).toList(),
        )
    );
  }

  _buildProviderList(BuildContext context, StakeProvidersStates state) {
    if(state is GetStakeProvidersLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ProgressDialog.showProgress(context);
      });
      return Container();
    }

    if(state is GetStakeProvidersFail) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ProgressDialog.dismiss(context);
      });

      String error = state.data;
      // Return error page
      return _buildErrorScreen(context, error);
    }

    if(state is GetStakeProvidersSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ProgressDialog.dismiss(context);
      });
    }

    List<Staking_providersBean?>? providers;
    if(_stakeProvidersBloc.useSearchResult) {
      providers = _stakeProvidersBloc.searchProviders;
    } else {
      providers = _stakeProvidersBloc.stakingProviders;
    }

    if(null == providers || providers.length == 0) {
      String error = 'No providers found!';
      return Container(
        child: Center(
          child: Text(error, textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Color(0xffd2d2d2)),),
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: providers.length,
      itemBuilder: (context, index) {
        return InkWell(
          child: _buildProviderItem(context, providers![index]!),
          onTap: () {
            providers![index]!.chosen = true;
            _stakeProvidersBloc.add(ChooseProviderEvent(index));
          });
      },
      separatorBuilder: (context, index) {
        return Container(height: 18.h);
      },
    );
  }

  _buildProviderItem(BuildContext context, Staking_providersBean? provider) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 16.h),
      decoration: BoxDecoration(
        border: Border.all(color: provider?.chosen ?? false ? Colors.blueAccent : Colors.black12, width: 0.5.w),
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: provider?.chosen ?? false ? Colors.blueAccent : Colors.black12,
            offset: Offset(0, 0), blurRadius: 5, spreadRadius: 2.0)
        ]
      ),
      child: Column(
        children: [
          Row(
            children: [
              CachedNetworkImage(
                maxHeightDiskCache: 200,
                imageUrl: provider?.providerLogo ?? '',
                width: 40.w,
                height: 40.w,
                placeholder: (context, url) => Image.asset('images/txn_stake.png', width: 40.w, height: 40.w,),
                errorWidget: (context, url, error) => Image.asset('images/txn_stake.png', width: 40.w, height: 40.w,),
              ),
              Container(width: 6.w,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(provider?.providerTitle ?? '',
                    textAlign: TextAlign.start, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.blueAccent),),
                  Container(height: 6.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${formatHashEllipsis(provider?.providerAddress ?? '', short: false)}', textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 14.sp, color: Colors.black54),),
                      Container(width: 3.w,),
                      provider?.addressVerification == 1 ?
                        Image.asset('images/verified.png', width: 12.w, height: 12.w,) : Container()
                    ],
                  )
                ],
              )
            ],
          ),
          Container(height: 12.h,),
          Container(
            padding: EdgeInsets.fromLTRB(0, 4.h, 0, 4.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 0.5.w),
              borderRadius: BorderRadius.all(Radius.circular(3.w)),
              color: Colors.white,
            ),
            child: Center(
              child: Text('Stake Pool Details', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
            ),
          ),
          Container(height: 12.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pool Size', textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Colors.grey),),
                  Container(height: 10.h,),
                  Text(formatKMBNumber(provider!.stakedSum!), textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black54),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Percent', textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Colors.grey),),
                  Container(height: 10.h,),
                  Text('${provider.stakePercent}%', textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black54),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fee', textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Colors.grey),),
                  Container(height: 10.h,),
                  Text('${provider.providerFee}%', textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black54),),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delegators', textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Colors.grey),),
                  Container(height: 10.h,),
                  Text(formatKMBNumber(provider.delegatorsNum!.toDouble()), textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black54),),
                ],
              ),
            ],
          ),
          Container(height: 12.h,),
          _buildPayoutTerms(context, provider.payoutTerms),
          (provider.payoutTerms == null
              || provider.payoutTerms!.isEmpty
              || provider.payoutTerms!.trim().isEmpty) ?
          Container() : Container(height: 8.h),
          (null == provider.website || provider.website!.isEmpty) ? Container() :
          Row(
            children: [
              Text('Pool Site:', textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d)),),
              Container(width: 3.w,),
              Expanded(
                child:
                Text(provider.website ?? '', textAlign: TextAlign.start, maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal, color: Colors.blue),),
                ),
            ],
          ),
          provider.chosen ? Container(height: 4.h,) : Container(),
          provider.chosen ? Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (null == provider.website || provider.website!.isEmpty) ? Container() :
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white24,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
                  side: BorderSide(width: 1.w, color: Colors.blueAccent)
                ),
                onPressed: () => showUrlWarningDialog(context, provider.website ?? ''),
                child: Text('OPEN SITE', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: Colors.blueAccent))),
              Container(width: 12.w),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white24,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
                    side: BorderSide(width: 1.w, color: Colors.blueAccent)
                ),
                onPressed: () {
                  SendData delegationData = SendData();
                  delegationData.isDelegation = true;
                  delegationData.to = provider.providerAddress!;
                  delegationData.memo = _getValidMemo(provider.providerTitle!);
                  delegationData.from = _accountIndex;
                  delegationData.amount = '0';
                  if(provider.providerId == 230
                      && provider.providerTitle == 'Everstake'
                      && provider.email == 'inbox@everstake.one') {
                    delegationData.isEverstake = true;
                  }
                  _gotoDelegationFee(context, delegationData);
                },
                child: Text('DELEGATE', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: Colors.blueAccent),)),
            ],
          ) : Container()
        ],
      )
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
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: Color(0xff2d2d2d))),
    );
    termWidgets.add(Container(width: 3.w,));

    terms.forEach((element) {
      termWidgets.add(Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffd0d0d0), width: 0.5.w),
          borderRadius: BorderRadius.all(Radius.circular(2.w)),
          color: Colors.white24,
        ),
        child: Text(element.trim(), textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.normal, color: Color(0xff2d2d2d)),),
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
              onTap: _getStakeProviders,
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
}
import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/service/coda_service.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NetworkSettingScreen extends StatefulWidget {
  NetworkSettingScreen({Key? key}) : super(key: key);

  @override
  _NetworkSettingScreenState createState() => _NetworkSettingScreenState();
}

class _NetworkSettingScreenState extends State<NetworkSettingScreen> {

  _getServerDomain(String? url) {
    if(null == url || url.isEmpty) {
      return '';
    }

    int index = url.indexOf('/', 8);
    return url.substring(0, index);
  }

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: buildNoTitleAppBar(context, actions: false),
      body: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: _buildNetworkSettingBody(context),
        decoration: BoxDecoration(
          color: Colors.white
        ),
      )
    );
  }

  _buildNetworkItems(BuildContext context) {
    List<DropdownMenuItem<int>> items = [];
    DropdownMenuItem<int> item0 = DropdownMenuItem(child: Text(NETWORK_LIST[0], style: TextStyle(fontSize: 22.sp),), value: 0);
    DropdownMenuItem<int> item1 = DropdownMenuItem(child: Text(NETWORK_LIST[1], style: TextStyle(fontSize: 22.sp),), value: 1);
    items.add(item0);
    items.add(item1);
    return items;
  }

  _buildNetworkSettingBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(height: 20.h,),
        DropdownButton(
          items: _buildNetworkItems(context),
          value: getCurrentNetworkId(),
          onChanged: (index) {
            setState(() {
              setCurrentNetworkId(index as int);
              // Coda service use singleton, so need to set the new client.
              CodaService().setClient(index);
              eventBus.fire(NetworkChange());
            });
          }
        ),
        Container(height: 24.h,),
        Text('Mina Broadcast Node', textAlign: TextAlign.left, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),),
        Container(height: 8.h,),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.w),
            color: Colors.white,
            border: Border.all(color: Color(0xff2d2d2d), width: 1.w)
          ),
          child: Text(_getServerDomain(RPC_SERVER_LIST[getCurrentNetworkId()]), style: TextStyle(fontSize: 16.sp)),
        ),
        Container(height: 24.h,),
        Text('Mina Archive Node', textAlign: TextAlign.left, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        Container(height: 8.h,),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.w),
            color: Colors.white,
            border: Border.all(color: Color(0xff2d2d2d), width: 1.w)
          ),
          child: Text(_getServerDomain(RPC_SERVER_LIST[getCurrentNetworkId()]), style: TextStyle(fontSize: 16.sp)),
        ),
      ],
    );
  }
}
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NetworkSettingScreen extends StatefulWidget {
  NetworkSettingScreen({Key key}) : super(key: key);

  @override
  _NetworkSettingScreenState createState() => _NetworkSettingScreenState();
}

class _NetworkSettingScreenState extends State<NetworkSettingScreen> {

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
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: buildNoTitleAppBar(context, actions: false),
      body: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: _buildNetworkSettingBody(context),
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.bottomCenter,
            image: AssetImage('images/common_bg.png',),
            fit: BoxFit.fitWidth
          ),
        ),
      )
    );
  }

  _buildCommonNodeItems(BuildContext context) {
    List<DropdownMenuItem<int>> items = List<DropdownMenuItem<int>>();
    DropdownMenuItem<int> item = DropdownMenuItem(child: Text('http://144.91.118.33:3085/graphql'), value: 0,);
    items.add(item);
    return items;
  }

  _buildArchiveNodeItems(BuildContext context) {
    List<DropdownMenuItem<int>> items = List<DropdownMenuItem<int>>();
    DropdownMenuItem<int> item = DropdownMenuItem(child: Text('https://graphql.minaexplorer.com'), value: 0,);
    items.add(item);
    return items;
  }

  _buildNetworkSettingBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(height: 20.h,),
        Container(
          width: double.infinity,
          child: Center(
            child: Text('Network Setting', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),),
          ),
        ),
        Container(height: 24.h,),
        Text('Mina Broadcast Node', textAlign: TextAlign.left, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),),
        Container(height: 8.h,),
        DropdownButton(
          items: _buildCommonNodeItems(context),
          hint: Text('http://144.91.118.33:3085/graphql'),
          value: 0,
          onChanged: (index) {

          }
        ),
        Container(height: 24.h,),
        Text('Mina Archive Node', textAlign: TextAlign.left, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        Container(height: 8.h,),
        DropdownButton(
          items: _buildArchiveNodeItems(context),
          hint: Text('https://graphql.minaexplorer.com'),
          value: 0,
          onChanged: (index) {

          }
        ),
      ],
    );
  }
}
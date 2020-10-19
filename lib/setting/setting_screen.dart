import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController _rpcEditingController = TextEditingController();

  _readRPCServer() async {
    String rpcServer = globalPreferences.getString(RPC_SERVER_KEY);
    _rpcEditingController.text = rpcServer;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _rpcEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(1080, 2316), allowFontScaling: false);
    return Scaffold(
      backgroundColor: Color(0xffeeeeee),
      appBar: _buildSettingAppBar(),
      body: _buildSettingBody()
    );
  }

  Widget _buildSettingBody() {
    _readRPCServer();
    return Container(
      margin: EdgeInsets.only(top: 6, bottom: 0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
            child: _buildRpcServerBody()
          ),
          Expanded(
            flex: 10,
            child: Container(
              padding: EdgeInsets.only(bottom: 20),
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(flex: 10, child: Container()),
                  RaisedButton(
                    padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 80, right: 80),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
                    onPressed: () => globalPreferences.setString(RPC_SERVER_KEY, _rpcEditingController.text),
                    color: Colors.blueAccent,
                    child: Text('Save', style: TextStyle(color: Colors.white),)
                  ),
                ]
              )
            ),
          )
        ]
      )
    );
  }

  Widget _buildRpcServerBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("RPC Server", textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold),),
        Container(height: 6),
        TextField(
          controller: _rpcEditingController,
          maxLines: 1,
          autofocus: false,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 1.0,
              ),
            ),
            hintText: 'RPC Server Address'
          )
        )
      ]
    );
  }

  Widget _buildSettingAppBar() {
    return PreferredSize(
        child: AppBar(
          title: Text('Setting',
              style: TextStyle(fontSize: APPBAR_TITLE_FONT_SIZE.sp, color: Color(0xff0b0f12))),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        preferredSize: Size.fromHeight(APPBAR_HEIGHT.h)
    );
  }
}
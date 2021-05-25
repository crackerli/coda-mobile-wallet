import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/widget/account/account_list.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAccountsScreen extends StatefulWidget {
  MyAccountsScreen({Key? key}) : super(key: key);

  @override
  _MyAccountsScreenState createState() => _MyAccountsScreenState();
}

class _MyAccountsScreenState extends State<MyAccountsScreen> {
  var _eventBusOn;

  @override
  void initState() {
    super.initState();
    _eventBusOn = eventBus.on<UpdateMyAccounts>().listen((event) {
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    print('MyAccountsScreen: dispose()');
    _eventBusOn.cancel();
    _eventBusOn = null;
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
    print('MyAccountsScreen: build(context: $context)');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff5f5f5),
      appBar: buildNoTitleAppBar(context, actions: false, backgroundColor: Color(0xfff5f5f5)),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          _buildMyAccountsBody(context),
          Positioned(
            bottom: 39.h,
            right: 31.w,
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed(CreateAccountRoute),
              child: Image.asset('images/create_account.png', width: 56.w, height: 56.w,)
            )
          )
        ],
      ),
    );
  }

  _buildMyAccountsBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 30.h),
        Padding(
          padding: EdgeInsets.only(left: 29.w, right: 29.w),
          child: Text('My Accounts', textAlign: TextAlign.left,
            style: TextStyle(fontSize: 28.sp, color: Color(0xff2d2d2d))),
        ),
        Container(height: 20.h),
        Expanded(
          flex: 1,
          child: buildAccountList(
            (index) {
              Navigator.of(context).pushNamed(AccountDetailRoute, arguments: index);
            })
        )
      ],
    );
  }
}

import 'package:coda_wallet/event_bus/event_bus.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/route/routes.dart';
import 'package:coda_wallet/widget/app_bar/app_bar.dart';
import 'package:coda_wallet/widget/ui/custom_box_shadow.dart';
import 'package:ffi_mina_signer/util/mina_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountDetailScreen extends StatefulWidget {

  AccountDetailScreen({Key? key}) : super(key: key);

  @override
  _AccountDetailScreenState createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  int _accountIndex = 0;
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
    print('AccountDetailScreen: build(context: $context)');
    _accountIndex = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: buildNoTitleAppBar(context, actions: false, backgroundColor: Color(0xfff5f5f5)),
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildAccountDetailBody(context),
          _buildActionsButton(context)
        ]
      )
    );
  }

  _buildActionsButton(BuildContext context) {
    return Positioned(
      bottom: 60.h,
      child: Builder(builder: (context) => InkWell(
        onTap: () => Navigator.pushNamed(context, EditAccountRoute, arguments: _accountIndex),
        child: Container(
          padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 100.w, right: 100.w),
          decoration: getMinaButtonDecoration(topColor: Color(0xffeeeeee)),
          child: Text('EDIT ACCOUNT',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Color(0xff2d2d2d))),
        ),
      ))
    );
  }

  _buildAccountDetailBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 30.h,),
        Padding(
          padding: EdgeInsets.only(left: 30.w, right: 30.w),
          child: Text(globalHDAccounts.accounts![_accountIndex]!.accountName ?? '',
            textAlign: TextAlign.left, style: TextStyle(fontSize: 28.sp, color: Color(0xff2d2d2d)))
        ),
        Container(height: 17.h,),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.only(top: 33.w, left: 30.w, right: 30.w),
              padding: EdgeInsets.only(top: 30.w + 12.h, left: 20.w, right: 20.w, bottom: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.w),
                color: Color(0xfff5f5f5),
                border: Border.all(color: Color(0xff2d2d2d), width: 1.w)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('BALANCE', textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Color(0xff616161))),
                  (globalHDAccounts.accounts![_accountIndex]!.isActive ?? false) ?
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${MinaHelper.getMinaStrByNanoStr(globalHDAccounts.accounts![_accountIndex]!.balance ?? '')} ',
                            style: TextStyle(fontSize: 24.sp, color: Color(0xff2d2d2d))),
                        TextSpan(
                          text: 'MINA',
                            style: TextStyle(color: Color(0xff2d2d2d), fontWeight: FontWeight.normal, fontSize: 14.sp)),
                      ]
                    )
                  ) : Text('Inactive', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.normal, fontSize: 18.sp)),
                  // Text('\$1234.56',
                  //   textAlign: TextAlign.left, style: TextStyle(fontSize: 18.sp, color: Color(0xff616161))),
                  Container(height: 19.h,),
                  Text('ADDRESS', textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Color(0xff616161))),
                  Container(height: 3.h,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.w),
                      color: Color(0xff9e9e9e),
                      border: Border.all(color: Color(0xff9e9e9e), width: 1.w)
                    ),
                    padding: EdgeInsets.only(top: 22.h, bottom: 22.h, left: 12.w, right: 12.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Builder(builder: (context) =>
                          InkWell(
                            child: Image.asset('images/copy_gray.png', width: 22.w, height: 27.h),
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: globalHDAccounts.accounts![_accountIndex]!.address));
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Your address copied into clipboard!!')));
                            },
                          )
                        ),
                        Container(width: 6.w,),
                        Flexible(child:
                          Text(globalHDAccounts.accounts![_accountIndex]!.address ?? '', maxLines: 3, overflow: TextOverflow.visible,
                            textAlign: TextAlign.left, style: TextStyle(fontSize: 12.sp, color: Color(0xff616161)))),
                      ],
                    )
                  )
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: Image.asset('images/mina_logo_black_inner.png', width: 66.w, height: 66.w,)
            )
          ],
        ),
        Container(height: 28.h,),
      ]
    );
  }
}

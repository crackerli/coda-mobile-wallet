import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressDialog {
  static bool _isShowing = false;

  static void showProgress(BuildContext context,
    {Widget child = const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xffB5B18C)))}) {
    if(!_isShowing) {
      _isShowing = true;
      Navigator.push(context, _PopRoute(child: _Progress(child: child)));
    }
  }

  static void dismiss(BuildContext context) {
    if(_isShowing) {
      Navigator.of(context).pop();
      _isShowing = false;
    }
  }
}

///Widget
class _Progress extends StatelessWidget {
  final Widget child;

  _Progress({
    Key? key,
    required this.child,
  }) : assert(child != null), super(key: key);

  @override
  Widget build(BuildContext context) {
 //   ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    ScreenUtil.init(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      designSize: Size(375, 812),
      orientation: Orientation.portrait
    );
    return WillPopScope(
      onWillPop: () {
        print('Progress Dialog dismissed');
        ProgressDialog._isShowing = false;
        return Future.value(true);
      },
      child: Center(child: SizedBox(width: 60.w, height: 60.w, child: child))
    );
  }
}

///Route
class _PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  _PopRoute({required this.child});

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => '';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}

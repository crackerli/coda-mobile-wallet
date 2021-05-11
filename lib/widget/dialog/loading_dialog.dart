import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    Key key,
    @required this.child,
  }) : assert(child != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: child,
      )
    );
  }
}

///Route
class _PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  _PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}

import 'dart:async';
import 'dart:io';
import 'package:flutter_secure_screen/flutter_secure_screen.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

/// Android can prevent the screen record, add FLAG_SECURE flag
/// In iOS, if screen recording or screenshot happen, just show a dialog to notify user
mixin ScreenRecordDetector {
  StreamSubscription<void>? _screenRecordListener;
  StreamSubscription<void>? _screenshotsListener;

  initDetector() async {
    if(Platform.isIOS) {
      FlutterSecureScreen.singleton.onScreenRecord?.listen(_onScreenRecord);
      FlutterSecureScreen.singleton.onScreenShots?.listen(_onScreenShot);
    } else if(Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } else {
      throw Exception('Unsupported platform');
    }
  }

  dismissDetector() async {
    if(Platform.isIOS) {
      _screenRecordListener?.cancel();
      _screenshotsListener?.cancel();
    } else if(Platform.isAndroid) {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } else {
      throw Exception('Unsupported platform');
    }
  }

  void _onScreenRecord(dynamic event) {
    showWarningAlert();
  }

  void _onScreenShot(dynamic event) {
    showWarningAlert();
  }

  // This api should be override by child widget
  void showWarningAlert() {
    print('screen shot detected');
  }
}
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences globalPreferences;
String globalRpcServer;
RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
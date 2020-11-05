import 'package:flutter/cupertino.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Global variables
SharedPreferences globalPreferences;
String globalRpcServer;
RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
const primaryBackgroundColor = Color(0xfff5f8fd);
const globalHPadding = 20;

// Global functions
String exceptionHandle<T>(QueryResult result) {
  if(null == result) {
    return 'Unknown Error';
  }

  if(result.hasException) {
    if(result.exception == null ||
      result.exception.graphqlErrors == null ||
      result.exception.graphqlErrors.length == 0) {
      return 'Network Error';
    }
  }
  GraphQLError error = result.exception?.graphqlErrors[0];
  return error.message;
}
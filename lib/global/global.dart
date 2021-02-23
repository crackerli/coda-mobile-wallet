import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// Global variables
SharedPreferences globalPreferences;
String globalRpcServer;
RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
const primaryBackgroundColor = Color(0xfff5f8fd);
const globalHPadding = 20;

// global mina unit price, will be retrieved from some exchanges at startup.
double gUnitFiatPrice = 2.317;

// global derived hd accounts from bip44 seed
MinaHDAccount globalHDAccounts = MinaHDAccount();

String globalEncryptedSeed;

const MAIN_NET_ID = 1;
const TEST_NET_ID = 0;

int globalNetworkId = TEST_NET_ID;

String getTokenFiatPrice(String tokenNumber) {
  double token = double.parse(tokenNumber);
  double ret = token * gUnitFiatPrice;
  return ret.toString();
}

// Global functions
String exceptionHandle<T>(QueryResult result) {
  if(null == result) {
    String error = 'Unknown Error';
    print(error);
    return error;
  }

  if(result.hasException) {
    if(result.exception == null ||
      result.exception.graphqlErrors == null ||
      result.exception.graphqlErrors.length == 0) {
      String error = 'Network Error, Please Check Network Connectivity And Try Again';
      print(error);
      return error;
    }
  }
  GraphQLError error = result.exception?.graphqlErrors[0];
  return error.message;
}

openUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
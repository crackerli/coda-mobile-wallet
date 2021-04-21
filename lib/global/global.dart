import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// Global variables
SharedPreferences globalPreferences;

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
const primaryBackgroundColor = Color(0xfff5f8fd);
const globalHPadding = 20;

// global mina unit price, will be retrieved from some exchanges at startup.
double gUnitFiatPrice = 2.317;

// global derived hd accounts from bip44 seed
MinaHDAccount globalHDAccounts = MinaHDAccount();

String globalEncryptedSeed;

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

int getCurrentNetworkId() {
  int currentNetworkId = globalPreferences.getInt(CURRENT_NETWORK_ID);

  if(null == currentNetworkId) {
    globalPreferences.setInt(CURRENT_NETWORK_ID, MAIN_NET_ID);
    return MAIN_NET_ID;
  }

  return currentNetworkId;
}

setCurrentNetworkId(int networkId) {
  int currentNetworkId = globalPreferences.getInt(CURRENT_NETWORK_ID);
  if(currentNetworkId == networkId) {
    return;
  }
  globalPreferences.setInt(CURRENT_NETWORK_ID, networkId);
}
import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/types/mina_hd_account_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// Global variables, used to manage the local saved data.
// For example, encrypted seed string, user derived accounts from seed, node as service provider list, etc.
late SharedPreferences globalPreferences;
late FlutterSecureStorage globalSecureStorage;

RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
const primaryBackgroundColor = Color(0xfff5f8fd);
const globalHPadding = 20;

// global derived hd accounts from bip44 seed
MinaHDAccount globalHDAccounts = MinaHDAccount();

// Encrypted seed read from local saved data or generated from recovery words
String? globalEncryptedSeed;

// Token number should be nano mina
// For precision, we convert all double to BigInt
String getTokenFiatPrice(String? tokenNumber) {
  if(null == tokenNumber || tokenNumber.isEmpty) {
    return '0.0';
  }
  String unitPriceStr = globalPreferences.getString(NOMICS_PRICE_KEY) ?? PRESET_MINA_PRICE;
  BigInt? nanoNumber = BigInt.tryParse(tokenNumber);
  if(null != nanoNumber) {
    // Only calc balance such as 0.0001
    BigInt tempTokenNumber = nanoNumber ~/ BigInt.from(100000);
    // Convert double price to BigInt
    double unitPrice = double.tryParse(unitPriceStr) ?? PRESET_MINA_PRICE_DOUBLE;
    BigInt tempUnitPrice = BigInt.from((unitPrice * 10000).toInt());
    BigInt totalPrice = tempUnitPrice * tempTokenNumber ~/ BigInt.from(10000 * 10);
    // Convert price in BigInt back to double
    return (totalPrice.toDouble() / 100.0 / 10.0).toStringAsFixed(2);
  }
  return '0.0';
}

// Global functions
String exceptionHandle<T>(QueryResult? result) {
  if(null == result) {
    String error = 'Unknown Error';
    print(error);
    return error;
  }

  if(result.hasException) {
    if(result.exception == null ||
      result.exception!.graphqlErrors.length == 0) {
      String error = 'Network Error, Please Check Network Connectivity And Try Again';
      print(error);
      return error;
    }
  }
  GraphQLError error = result.exception!.graphqlErrors[0];
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
  int? currentNetworkId = globalPreferences.getInt(CURRENT_NETWORK_ID);

  if(null == currentNetworkId) {
    globalPreferences.setInt(CURRENT_NETWORK_ID, MAIN_NET_ID);
    return MAIN_NET_ID;
  }

  return currentNetworkId;
}

setCurrentNetworkId(int networkId) {
  int? currentNetworkId = globalPreferences.getInt(CURRENT_NETWORK_ID);
  if(currentNetworkId == networkId) {
    return;
  }
  globalPreferences.setInt(CURRENT_NETWORK_ID, networkId);
}
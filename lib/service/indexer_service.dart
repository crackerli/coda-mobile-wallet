import 'dart:io';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/build_config.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class IndexerService {

  static final IndexerService _instance = IndexerService._internal();
  Dio _client;

  factory IndexerService() => _instance;

  IndexerService._internal() {
    if (null == _client) {
      BaseOptions options = BaseOptions();
      options.baseUrl = "$DEFAULT_INDEXER_SERVER/transactions";
      options.receiveTimeout = 1000 * 15;
      options.connectTimeout = 10000;
      _client = Dio(options);

      (_client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
        client.findProxy = (url) {
          if(debugConfig) {
            return "PROXY 192.168.84.201:9999";
          } else {
            return 'DIRECT';
          }
        };

        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }

  Future<Response> getTransactions(String account) async {
    String requestUrl = "$DEFAULT_INDEXER_SERVER/transactions";

    Map<String, dynamic> map = Map<String, dynamic>();
    map['account']= account;

    Response response = await _client.get(requestUrl, queryParameters: map);

    return response;
  }
}
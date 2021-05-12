import 'dart:io';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/build_config.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class IndexerService {

  static final IndexerService _instance = IndexerService._internal();
  Dio _client;

  factory IndexerService() => _instance;

  IndexerService._internal() {
    if (null == _client) {
      BaseOptions options = BaseOptions();
//      options.baseUrl = "$DEFAULT_INDEXER_SERVER/transactions";
      options.receiveTimeout = 1000 * 60;
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
    int networkId = getCurrentNetworkId();
    String indexerServer = INDEXER_SERVER_LIST[networkId];
    String requestUrl = "$indexerServer/transactions";
    print('Current indexer server using: $requestUrl');

    Map<String, dynamic> map = Map<String, dynamic>();
    map['account']= account;

    Response response = await _client.get(requestUrl, queryParameters: map);

    return response;
  }

  Future<Response> getProviders() async {
    Response response = await _client.get(STAKETAB_PROVIDERS);
    return response;
  }
}
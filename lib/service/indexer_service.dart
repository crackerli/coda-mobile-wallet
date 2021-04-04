import 'dart:io';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/build_config.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class IndexerService {
  Dio _dio;

  IndexerService() {
    _dio = Dio();

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
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

  Future<Response> getTransactions(String account) async {
    String requestUrl = "$DEFAULT_INDEXER_SERVER/transactions";

    Map<String, dynamic> map = Map();
    map['account']= account;

    Response response = await _dio.get(requestUrl, queryParameters: map);

    return response;
  }
}
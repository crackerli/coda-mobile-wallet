import 'dart:io';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/build_config.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class IndexerService {

  static final IndexerService _instance = IndexerService._internal();
  Dio? _client;

  factory IndexerService() => _instance;

  IndexerService._internal() {
    if (null == _client) {
      BaseOptions options = BaseOptions();
      options.receiveTimeout = Duration(seconds: 60);
      options.connectTimeout = Duration(seconds: 20);
      _client = Dio(options);

      (_client!.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
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

  Future<Response> getProviders() async {
    Response response = await _client!.get(STAKETAB_PROVIDERS);
    return response;
  }

  Future<Response> getExchangeInfo() async {
    Response response = await _client!.get(NOMICS_QUERY_URL);
    return response;
  }
}
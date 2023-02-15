import 'package:coda_wallet/global/build_config.dart';
import 'package:graphql/client.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class ArchiveService {
  static final ArchiveService _instance = ArchiveService._internal();

  factory ArchiveService() => _instance;
  late GraphQLClient _client;

  ArchiveService._internal() {
    HttpClient httpClient = HttpClient();
    IOClient ioClient;
    if(debugConfig) {
      httpClient.findProxy = (url) {
        return HttpClient.findProxyFromEnvironment(
            url, environment: {'http_proxy': 'http://192.168.84.201:9999'});
      };
    }

    ioClient = IOClient(httpClient);
    String archiveServer = 'https://graphql.minaexplorer.com/';
    print('archive service using: $archiveServer');
    final HttpLink httpLink = HttpLink(
        archiveServer,
        defaultHeaders: <String, String> {
          'content-type': 'application/json',
        },
        httpClient: ioClient
    );

    _client = GraphQLClient(link: httpLink, cache: GraphQLCache());
  }

  Future<QueryResult> performQuery(String query,
      {Map<String, dynamic> variables = const {}}) async {
    QueryOptions options = QueryOptions(document: gql(query), variables: variables, fetchPolicy: FetchPolicy.cacheAndNetwork);

    final result = await _client.query(options);

    return result;
  }
}

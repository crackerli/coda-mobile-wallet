import 'package:coda_wallet/global/build_config.dart';
import 'package:graphql/client.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class MinaExplorerService {
  static final MinaExplorerService _instance = MinaExplorerService._internal();

  factory MinaExplorerService() => _instance;
  late GraphQLClient _client;

  MinaExplorerService._internal() {
    HttpClient httpClient = HttpClient();
    IOClient ioClient;
    if(debugConfig) {
      httpClient.findProxy = (url) {
        return HttpClient.findProxyFromEnvironment(
          url, environment: {'http_proxy': 'http://192.168.84.201:9999'});
      };
    }

    ioClient = IOClient(httpClient);
    String explorerServer = 'https://graphql.minaexplorer.com/';
    final HttpLink httpLink = HttpLink(
      explorerServer,
      defaultHeaders: <String, String> {
        'content-type': 'application/json',
      },
      httpClient: ioClient
    );

    var graphqlCache = GraphQLCache();
    graphqlCache.addTypename = false;
    _client = GraphQLClient(link: httpLink, cache: graphqlCache);
  }

  Future<QueryResult> performQuery(String query,
    {Map<String, dynamic> variables = const {}}) async {
    QueryOptions options = QueryOptions(document: gql(query), variables: variables, fetchPolicy: FetchPolicy.cacheAndNetwork);

    final result = await _client.query(options);

    return result;
  }
}

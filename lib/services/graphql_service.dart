import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLService {
  static const String _baseUrl =
      'http://92.205.167.80:8080/v1/graphql';

  static Future<GraphQLClient> getClient() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final HttpLink httpLink = HttpLink(
      _baseUrl,
      defaultHeaders: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }

  static Future<GraphQLClient> getUnauthenticatedClient() async {
    final HttpLink httpLink = HttpLink(
      _baseUrl,
      defaultHeaders: {
        'Content-Type': 'application/json',
      },
    );

    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }
}

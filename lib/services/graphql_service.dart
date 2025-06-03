import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import '../../app/service_locator.dart';

class GraphQLService {
  static const String _baseUrl = 'http://92.205.167.80:8080/v1/graphql';
  final _secureStorage = const FlutterSecureStorage();
  final _authService = locator<AuthService>();

  static Future<GraphQLClient> getClient() async {
    final service = GraphQLService();
    return await service._getClient();
  }

  Future<GraphQLClient> _getClient() async {
    final token = await _secureStorage.read(key: 'access_token');

    final HttpLink httpLink = HttpLink(
      _baseUrl,
      defaultHeaders: {
        'Content-Type': 'application/json',
        'x-hasura-admin-secret': '123',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    final AuthLink authLink = AuthLink(
      getToken: () async {
        final token = await _secureStorage.read(key: 'access_token');
        return token != null ? 'Bearer $token' : null;
      },
    );

    final Link link = authLink.concat(httpLink);

    return GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );
  }

  static Future<GraphQLClient> getUnauthenticatedClient() async {
    final HttpLink httpLink = HttpLink(
      _baseUrl,
      defaultHeaders: {
        'Content-Type': 'application/json',
        'x-hasura-admin-secret': '123',
      },
    );

    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }
}

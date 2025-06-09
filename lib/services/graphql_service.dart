import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import '../../app/service_locator.dart';

class GraphQLService {
  static const String _baseUrl = 'http://92.205.167.80:8080/v1/graphql';
  final _secureStorage = const FlutterSecureStorage();
  final _authService = locator<AuthService>();

  // Define possible roles
  static const String roleMe = 'me';
  static const String roleUser = 'user';
  static const String roleAdmin = 'user_me';

  // Define authentication states
  static const String authStateUnauthenticated = 'unauthenticated';
  static const String authStateAuthenticated = 'authenticated';

  static Future<GraphQLClient> getClient({String? role}) async {
    final service = GraphQLService();
    return await service._getClient(role: role);
  }

  Future<GraphQLClient> _getClient({String? role}) async {
    final token = await _secureStorage.read(key: 'access_token');

    // If no token is present, use unauthenticated client
    if (token == null) {
      return _getUnauthenticatedClient();
    }

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'x-hasura-admin-secret': '123',
    };

    // Add role header if specified (this will override the default role from JWT)
    if (role != null) {
      headers['x-hasura-role'] = role;
    }

    final HttpLink httpLink = HttpLink(
      _baseUrl,
      defaultHeaders: headers,
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
    final service = GraphQLService();
    return service._getUnauthenticatedClient();
  }

  Future<GraphQLClient> _getUnauthenticatedClient() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'x-hasura-admin-secret': '123',
    };

    final HttpLink httpLink = HttpLink(
      _baseUrl,
      defaultHeaders: headers,
    );

    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }
}

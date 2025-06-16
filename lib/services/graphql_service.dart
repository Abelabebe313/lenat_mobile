import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import '../../app/service_locator.dart';
import 'dart:convert';

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
    print("token: $token");
    // If no token is present, use unauthenticated client
    if (token == null) {
      return _getUnauthenticatedClient();
    }

    // Get user data to extract user ID
    final userDataStr = await _secureStorage.read(key: 'user_data');
    if (userDataStr == null) {
      throw Exception('User data not found');
    }
    final userData = jsonDecode(userDataStr) as Map<String, dynamic>;
    final userId = userData['id'] as String;

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'x-hasura-role': role ?? GraphQLService.roleMe,
      'x-hasura-user-id': userId,
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

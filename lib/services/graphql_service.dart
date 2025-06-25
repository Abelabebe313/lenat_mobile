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
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    print("token: $token");
    print("refreshToken: $refreshToken");
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

  // Helper method to refresh token
  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refresh_token');

      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final client = await _getUnauthenticatedClient();
      const mutation = r'''
        mutation($refresh_token: String!) {
          auth_refresh_tokens(refresh_token: $refresh_token) {
            access_token
            refresh_token
          }
        }
      ''';

      final result = await client.mutate(
        MutationOptions(
          document: gql(mutation),
          variables: {'refresh_token': refreshToken},
        ),
      );

      if (result.hasException) {
        final message = result.exception?.graphqlErrors.first.message ??
            'Failed to refresh token';

        if (message.contains('Token has expired')) {
          print('❌ Refresh token has expired. Logging out...');
          await _secureStorage.deleteAll();
          throw Exception('Token has expired');
        }

        throw Exception(message);
      }

      final data = result.data?['auth_refresh_tokens'];
      if (data != null) {
        await _secureStorage.write(
            key: 'access_token', value: data['access_token']);
        await _secureStorage.write(
            key: 'refresh_token', value: data['refresh_token']);
        return data['access_token'];
      }

      return null;
    } catch (e) {
      print('Error refreshing token: $e');
      rethrow;
    }
  }

  // Helper method to execute operations with automatic token refresh
  static Future<QueryResult> executeWithTokenRefresh(
    Future<QueryResult> Function() operation,
  ) async {
    final service = GraphQLService();

    try {
      return await operation();
    } catch (e) {
      // Check if it's a JWT expired error
      if (e.toString().contains('JWTExpired') ||
          e.toString().contains('Could not verify JWT')) {
        print('JWT expired, refreshing token...');

        try {
          // Try to refresh the token
          final newToken = await service._refreshToken();
          if (newToken != null) {
            print('Token refreshed successfully, retrying operation...');
            // Retry the operation with the new token
            return await operation();
          } else {
            throw Exception('Failed to refresh token');
          }
        } catch (refreshError) {
          // Check if refresh token is expired
          if (refreshError.toString().contains('Token has expired')) {
            throw Exception('Token has expired');
          }
          rethrow;
        }
      }
      rethrow;
    }
  }
}

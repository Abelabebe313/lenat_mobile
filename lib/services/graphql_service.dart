import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import '../../app/service_locator.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

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

  static Future<GraphQLClient> getClientWithOutRoleandUserId() async {
    final service = GraphQLService();
    return await service._getClientWithOutRoleandUserId();
  }

  Future<GraphQLClient> _getClientWithOutRoleandUserId() async {
    final token = await _secureStorage.read(key: 'access_token');
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
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

  static Future<GraphQLClient> getClientWithOutRole() async {
    final service = GraphQLService();
    return await service._getClientWithOutRole();
  }

  Future<GraphQLClient> _getClientWithOutRole() async {
    final token = await _secureStorage.read(key: 'access_token');
    final refreshToken = await _secureStorage.read(key: 'refresh_token');

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

  // Simple method to refresh tokens
  static Future<bool> refreshTokens() async {
    try {
      final secureStorage = const FlutterSecureStorage();
      final refreshToken = await secureStorage.read(key: 'refresh_token');
      final accessToken = await secureStorage.read(key: 'access_token');

      if (refreshToken == null || accessToken == null) {
        print('No refresh token or access token available');
        return false;
      }

      // Create a client specifically for token refresh with all required headers
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $accessToken',
      };

      final HttpLink httpLink = HttpLink(
        _baseUrl,
        defaultHeaders: headers,
      );

      final client = GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      );

      const mutation = r'''
        mutation RefreshTokens($refreshToken: String!) {
          auth_refresh_tokens(refresh_token: $refreshToken) {
            access_token
            refresh_token
          }
        }
      ''';

      final result = await client.mutate(
        MutationOptions(
          document: gql(mutation),
          variables: {'refreshToken': refreshToken},
        ),
      );

      if (result.hasException) {
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              'GraphQL errors: ${result.exception?.graphqlErrors.map((e) => "${e.message} (${e.path})")}');
        }
        if (result.exception?.linkException != null) {
          print('Link exception: ${result.exception?.linkException}');
        }
        return false;
      }

      if (result.data == null || result.data!['auth_refresh_tokens'] == null) {
        print('Token refresh returned null data: ${result.data}');
        return false;
      }

      final newAccessToken =
          result.data?['auth_refresh_tokens']['access_token'];
      final newRefreshToken =
          result.data?['auth_refresh_tokens']['refresh_token'];

      if (newAccessToken == null || newRefreshToken == null) {
        print(
            'Invalid token data received: ${result.data?['auth_refresh_tokens']}');
        return false;
      }

      // Store the new tokens - both must be updated since refresh token is one-time use
      await secureStorage.write(key: 'access_token', value: newAccessToken);
      await secureStorage.write(key: 'refresh_token', value: newRefreshToken);

      return true;
    } catch (e) {
      print('Error refreshing tokens: $e');
      return false;
    }
  }

  // Check if a result has authentication errors
  static bool hasAuthError(QueryResult result) {
    if (!result.hasException) return false;

    // Check for common authentication error messages
    final hasGraphQLAuthError = result.exception?.graphqlErrors.any((error) =>
            error.message.contains('JWT') ||
            error.message.contains('token') ||
            error.message.contains('Token') ||
            error.message.contains('authentication') ||
            error.message.contains('Authentication') ||
            error.message.contains('unauthorized') ||
            error.message.contains('Unauthorized') ||
            error.message.contains('expired') ||
            error.message.contains('Expired')) ??
        false;

    // Check for network errors that might be auth-related
    final hasNetworkAuthError = result.exception?.linkException != null &&
        result.exception!.linkException.toString().contains('401');

    return hasGraphQLAuthError || hasNetworkAuthError;
  }

  // Helper to redirect to login
  static void redirectToLogin(BuildContext context) {
    // Clear tokens
    const FlutterSecureStorage().deleteAll();

    // Navigate to login and clear the stack
    Navigator.of(context, rootNavigator: true)
        .pushNamedAndRemoveUntil('/login', (_) => false);
  }
}

extension GraphQLClientExtension on GraphQLClient {
  // Execute a query with token refresh if needed
  Future<QueryResult> queryWithTokenRefresh(
    QueryOptions options, {
    BuildContext? context,
  }) async {
    try {
      // First attempt
      final result = await this.query(options);

      // Check for auth errors
      if (GraphQLService.hasAuthError(result)) {
        // Try to refresh the token
        final refreshed = await GraphQLService.refreshTokens();

        if (refreshed) {
          // If refresh succeeded, get a new client and retry
          final newClient = await GraphQLService.getClient();
          return await newClient.query(options);
        } else {
          if (context != null) {
            GraphQLService.redirectToLogin(context);
          }
        }
      }

      return result;
    } catch (e) {
      print('Error in queryWithTokenRefresh: $e');
      rethrow;
    }
  }

  // Execute a mutation with token refresh if needed
  Future<QueryResult> mutationWithTokenRefresh(
    MutationOptions options, {
    BuildContext? context,
  }) async {
    try {
      // First attempt
      final result = await this.mutate(options);

      // Check for auth errors
      if (GraphQLService.hasAuthError(result)) {
        final refreshed = await GraphQLService.refreshTokens();

        if (refreshed) {
          // If refresh succeeded, get a new client and retry
          final newClient = await GraphQLService.getClient();
          return await newClient.mutate(options);
        } else {
          if (context != null) {
            GraphQLService.redirectToLogin(context);
          }
        }
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}

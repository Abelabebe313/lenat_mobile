import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lenat_mobile/models/catagory_model.dart';
import 'package:lenat_mobile/models/market_product_model.dart';
import 'package:lenat_mobile/services/graphql_service.dart';
import 'dart:convert'; // Added for jsonEncode

class MarketPlaceService {
  static const String _getProductsByCategoryQuery = '''
    query GetMarketPlaceProductsByCategory(\$category_id: uuid!) {
      marketplace_products(where: {product_categories: {category_id: {_eq: \$category_id}}})
      {
        id
        is_active
        is_featured
        name
        description
        price
        variants
        state
        product_images {
          product_id
          media_id
          medium {
            url
            blur_hash
          }
        }
      }
    }
  ''';

  static const String _getFeaturedProductsQuery = '''
    query GetMarketPlaceProducts{
      marketplace_products(where: {is_featured: {_eq: true}})
      {
        id
        is_active
        is_featured
        name
        description
        price
        variants
        state
        product_images {
          product_id
          media_id
          medium {
            url
            blur_hash
          }
        }
      }
    }
  ''';

  static const String _getMarketPlaceProductsByIdQuery = '''
   query MarketProductById(\$id: String!) {
      marketplace_products(where: {id: {_eq: "\$id"}}) {
        id
        is_active
        is_featured
        name
        description
        price
        variants
        state
        product_images {
          product_id
          media_id
          medium {
            url
            blur_hash
          }
        }
      }
    }
  ''';

  static const String _getMarketPlaceCatagoryQuery = '''
    query GetMarketPlaceProducts{
      marketplace_categories{
        id
        name
      }
    }
  ''';

  static const String _createOrder = '''
    mutation CREATE_ORDER(\$items: json!) {
      marketplace_create_order(args: {p_items: \$items}) {
        success
        order_id
        message
      }
    }
  ''';

  // ===============Load products by category===============
  Future<List<MarketPlaceModel>> getProductsbyCategory(
    String categoryId, {
    bool refresh = false,
  }) async {
    try {
      // Refresh tokens first to ensure we have valid tokens
      await GraphQLService.refreshTokens();
      final client = await GraphQLService.getUnauthenticatedClient();

      print("=>categoryId${categoryId}");

      final QueryOptions options = QueryOptions(
        document: gql(_getProductsByCategoryQuery),
        variables: {'category_id': categoryId},
      );

      final QueryResult result = await client.queryWithTokenRefresh(options);

      if (result.hasException) {
        print('Error fetching products by category: ${result.exception}');
        throw result.exception!;
      }

      final List<dynamic> marketplaceProducts =
          result.data?['marketplace_products'] as List<dynamic>;
      return marketplaceProducts
          .map((product) => MarketPlaceModel.fromJson(product))
          .toList();
    } catch (e) {
      print('Exception in getFeaturedMarketPlaceProducts: $e');
      throw Exception('Failed to fetch featured market place products: $e');
    }
  }

  // ===============Load featured products===============
  Future<List<MarketPlaceModel>> getFeaturedProducts({
    bool refresh = false,
  }) async {
    try {
      // Refresh tokens first to ensure we have valid tokens
      await GraphQLService.refreshTokens();
      final client = await GraphQLService.getClientWithOutRoleandUserId();

      final QueryOptions options = QueryOptions(
        document: gql(_getFeaturedProductsQuery),
        fetchPolicy:
            refresh ? FetchPolicy.networkOnly : FetchPolicy.cacheAndNetwork,
      );

      final QueryResult result = await client.queryWithTokenRefresh(options);

      if (result.hasException) {
        print('Error fetching products by featured: ${result.exception}');
        throw result.exception!;
      }

      final List<dynamic> marketplaceProducts =
          result.data?['marketplace_products'] as List<dynamic>;
      return marketplaceProducts
          .map((product) => MarketPlaceModel.fromJson(product))
          .toList();
    } catch (e) {
      print('Exception in getFeaturedMarketPlaceProducts: $e');
      throw Exception('Failed to fetch featured market place products: $e');
    }
  }

  Future<MarketPlaceModel> getMarketPlaceProductsByIdQuery(String id) async {
    final client = await GraphQLService.getClientWithOutRoleandUserId();
    final QueryOptions options = QueryOptions(
      document: gql(_getMarketPlaceProductsByIdQuery),
      variables: {'id': id},
    );
    final QueryResult result = await client.queryWithTokenRefresh(options);
    if (result.hasException) {
      print('Error fetching products: ${result.exception}');
      throw result.exception!;
    }
    return MarketPlaceModel.fromJson(result.data?['marketplace_products'][0]);
  }

  Future<List<CategoryModel>> getMarketPlaceCatagory() async {
    await GraphQLService.refreshTokens();
    final client = await GraphQLService.getClientWithOutRoleandUserId();

    final QueryOptions options = QueryOptions(
      document: gql(_getMarketPlaceCatagoryQuery),
    );

    final QueryResult result = await client.queryWithTokenRefresh(options);
    final List<dynamic> categories =
        result.data?['marketplace_categories'] as List<dynamic>;
    return categories
        .map((category) => CategoryModel.fromJson(category))
        .toList();
  }

  // ===============Create order===============
  Future<Map<String, dynamic>> createOrder(
      List<Map<String, dynamic>> items) async {
    try {
      // Refresh tokens first to ensure we have valid tokens
      await GraphQLService.refreshTokens();
      final client = await GraphQLService.getClientWithOutRole();

      // Pass the items array directly as the variable
      print('Items: $items');

      final MutationOptions options = MutationOptions(
        document: gql(_createOrder),
        variables: {
          'items':
              items, // Pass the items array directly, not wrapped in another object
        },
      );

      final QueryResult result = await client.mutationWithTokenRefresh(options);

      if (result.hasException) {
        print('Error creating order: ${result.exception}');
        throw result.exception!;
      }

      // Debug the response
      print('Order creation response: ${result.data}');

      // Check if the response data is available
      if (result.data == null ||
          result.data!['marketplace_create_order'] == null) {
        throw Exception('Invalid response data from server');
      }

      // Get the response data
      final responseData = result.data!['marketplace_create_order'];

      // Try to convert the response to a Map
      try {
        if (responseData is List && responseData.isNotEmpty) {
          return Map<String, dynamic>.from(responseData.first);
        } else if (responseData is Map) {
          return Map<String, dynamic>.from(responseData);
        } else {
          // Create a default success response
          return {
            'success': true,
            'order_id': 'unknown',
            'message': 'Order created successfully'
          };
        }
      } catch (e) {
        print('Error converting response: $e');
        return {
          'success': true,
          'order_id': 'unknown',
          'message': 'Order created but response format was unexpected'
        };
      }
    } catch (e) {
      print('Exception in createOrder: $e');
      throw Exception('Failed to create order: $e');
    }
  }
}

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lenat_mobile/models/market_product_model.dart';
import 'package:lenat_mobile/services/graphql_service.dart';

class MarketPlaceService {
  static const String _getFeaturedMarketPlaceProductsQuery = '''
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
      marketplace_categories(where: {is_active: {_eq: true}})
      {
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

  Future<List<MarketPlaceModel>> getFeaturedMarketPlaceProducts({
    bool refresh = false,
  }) async {
    try {
      // Refresh tokens first to ensure we have valid tokens
      await GraphQLService.refreshTokens();
      final client = await GraphQLService.getClientWithOutRoleandUserId();

      final QueryOptions options = QueryOptions(
        document: gql(_getFeaturedMarketPlaceProductsQuery),
        fetchPolicy:
            refresh ? FetchPolicy.networkOnly : FetchPolicy.cacheAndNetwork,
      );

      final QueryResult result = await client.queryWithTokenRefresh(options);

      if (result.hasException) {
        print('Error fetching products: ${result.exception}');
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

  Future<List<String>> getMarketPlaceCatagory() async {
    final client = await GraphQLService.getClientWithOutRoleandUserId();
    final QueryOptions options = QueryOptions(
      document: gql(_getMarketPlaceCatagoryQuery),
    );
    final QueryResult result = await client.queryWithTokenRefresh(options);
    return result.data?['marketplace_categories']
        .map((category) => category['name'])
        .toList();
  }
}

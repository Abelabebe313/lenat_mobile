import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lenat_mobile/services/graphql_service.dart';
import '../models/feed_model.dart';

class FeedPostService {
  static const int _defaultLimit = 5; // Default number of posts to fetch

  static const String _getFeedPostsQuery = '''
    query GetFeedPosts(\$limit: Int!) {
      feed_get_random_posts(limit: \$limit) {
        id
        user_id
        is_bookmarked
        is_liked
        description
        state
        media_id
        created_at
        updated_at
        media {
          id
          owner_id
          url
          file_name
          created_at
          blur_hash
        }
      }
    }
  ''';

  Future<List<FeedPostModel>> getFeedPosts({
    int limit = _defaultLimit,
    bool refresh = false,
  }) async {
    final client = await GraphQLService.getUnauthenticatedClient();

    final QueryOptions options = QueryOptions(
      document: gql(_getFeedPostsQuery),
      variables: {
        'limit': limit,
      },
    );

    try {
      final QueryResult result = await client.query(options);

      if (result.hasException) {
        throw result.exception!;
      }

      final List<dynamic> posts =
          result.data?['feed_get_random_posts'] as List<dynamic>;
      return posts.map((post) => FeedPostModel.fromJson(post)).toList();
    } catch (e) {
      throw Exception('Failed to fetch feed posts: $e');
    }
  }

  // Method to prefetch next batch of posts
  Future<void> prefetchNextPosts() async {
    await getFeedPosts();
  }
}

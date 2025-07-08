import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lenat_mobile/services/graphql_service.dart';
import '../models/feed_model.dart';

class FeedPostService {
  static const int _defaultLimit = 5; // Default number of posts to fetch

  static const String _getFeedPostsQuery = '''
    query GetFeedPosts(\$category: enum_feed_type_enum){
      feed_get_random_posts(where: {category: {_eq: \$category}})
      {
        id
        user_id
        is_bookmarked
        is_liked
        description
        state
        media_id
        created_at
        updated_at
        category
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

  static const String _bookmarkPostMutation = '''
    mutation BookmarkPost(\$postId: uuid!) {
      insert_feed_bookmarks_one(object: {post_id: \$postId}) {
        post_id
      }
    }
  ''';

  static const String _removeBookmarkMutation = '''
    mutation RemoveBookmark(\$postId: uuid!) {
      delete_feed_bookmarks(where: {post_id: {_eq: \$postId}}) {
        affected_rows
      }
    }
  ''';

  static const String _getBookmarkedFeedPostsQuery = '''
    query GetBookmarkedFeedPosts {
      feed_posts(where: {is_bookmarked: {_eq: true}}) {
        id
        is_bookmarked
        is_liked
        description
        media_id
        category
        media {
          id
          url
          file_name
          blur_hash
        }
      }
    }
  ''';

  Future<List<FeedPostModel>> getFeedPosts({
    int limit = _defaultLimit,
    bool refresh = false,
    String? category,
  }) async {
    print('getFeedPosts: $limit, $refresh, $category');
    final client = await GraphQLService.getUnauthenticatedClient();

    final QueryOptions options = QueryOptions(
      document: gql(_getFeedPostsQuery),
      variables: {
        'category': category,
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

  // Method to bookmark a post
  Future<bool> bookmarkPost(String postId) async {
    await GraphQLService.refreshTokens();
    final client = await GraphQLService.getClientWithOutRoleandUserId();

    final MutationOptions options = MutationOptions(
      document: gql(_bookmarkPostMutation),
      variables: {
        'postId': postId,
      },
    );
    try {
      final QueryResult result = await client.mutationWithTokenRefresh(options);
      print("===========$result===========");
      if (result.hasException) {
        print('Error bookmarking post: ${result.exception}');
        return false;
      }

      return true;
    } catch (e) {
      print('Exception bookmarking post: $e');
      return false;
    }
  }

  // Method to remove bookmark from a post
  Future<bool> removeBookmark(String postId) async {
    try {
      // Always refresh tokens before removing bookmark
      await GraphQLService.refreshTokens();

      final client = await GraphQLService.getClientWithOutRoleandUserId();

      final MutationOptions options = MutationOptions(
        document: gql(_removeBookmarkMutation),
        variables: {
          'postId': postId,
        },
      );

      final QueryResult result = await client.mutationWithTokenRefresh(options);

      if (result.hasException) {
        print('Error removing bookmark: ${result.exception}');
        return false;
      }

      final int affectedRows =
          result.data?['delete_feed_bookmarks']['affected_rows'] ?? 0;
      return affectedRows > 0;
    } catch (e) {
      print('Exception removing bookmark: $e');
      return false;
    }
  }

  Future<List<FeedPostModel>> getBookmarkedFeedPosts() async {
    await GraphQLService.refreshTokens();
    final client = await GraphQLService.getClientWithOutRole();

    final QueryOptions options = QueryOptions(
      document: gql(_getBookmarkedFeedPostsQuery),
    );

    try {
      final QueryResult result = await client.queryWithTokenRefresh(options);

      if (result.hasException) {
        throw result.exception!;
      }

      final List<dynamic> posts = result.data?['feed_posts'] as List<dynamic>;
      return posts.map((post) => FeedPostModel.fromJson(post)).toList();
    } catch (e) {
      throw Exception('Failed to fetch feed posts: $e');
    }
  }

  // Method to prefetch next batch of posts
  Future<void> prefetchNextPosts({String? category}) async {
    await getFeedPosts(category: category);
  }
}

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lenat_mobile/models/feed_model.dart';
import 'dart:math' as math;

class HomeViewModel extends ChangeNotifier {
  List blogs = [];
  FeedPostModel? randomHighlightPost;
  bool isLoadingHighlight = false;

  String getBlogsQuery = r'''
    query GetBlogs {
      blog_posts(where: { title: { _is_null: false } }) {
        id
        title
        content
        created_at
        media {
          url
        }
      }
    }
  ''';

  String getRandomHighlightQuery = r'''
    query GetRandomHighlight($timestamp: String!) {
      feed_get_random_posts(where: {category: {_is_null: false}}, limit: 10) {
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

  // Alternative query using regular feed_posts with random offset
  String getAlternativeRandomQuery = '''
    query GetAlternativeRandom(\$offset: Int!) {
      feed_posts(where: {category: {_is_null: false}}, limit: 1, offset: \$offset) {
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

  void getBlogs(BuildContext context) async {
    final client = GraphQLProvider.of(context).value;

    final result = await client.query(
      QueryOptions(document: gql(getBlogsQuery)),
    );

    if (result.hasException) {
      print(result.exception.toString());
    } else {
      print(result.data);
      // Or use setState to store and display appointments
      var blogsUnfiltered = result.data!["blog_posts"];
      blogs = result.data!["blog_posts"];
      print(blogsUnfiltered.length);

      // blogs = blogsUnfiltered.map((eachBlog) => eachBlog["title"] != Null);
      print(blogs.length);
      notifyListeners();
    }
  }

  void getRandomHighlight(BuildContext context) async {
    print('getRandomHighlight called, isLoadingHighlight: $isLoadingHighlight');
    if (isLoadingHighlight) return;
    
    isLoadingHighlight = true;
    notifyListeners();
    print('Started fetching random highlight');

    try {
      final client = GraphQLProvider.of(context).value;
      print('GraphQL client obtained, executing query');
      
      // Add timestamp to prevent caching
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      print('Using timestamp: $timestamp');
      
      final result = await client.query(
        QueryOptions(
          document: gql(getRandomHighlightQuery),
          variables: {
            'timestamp': timestamp,
          },
        ),
      );

      if (result.hasException) {
        print('Error fetching random highlight: ${result.exception.toString()}');
      } else {
        print('Query successful, data: ${result.data}');
        final List<dynamic> posts = result.data!["feed_get_random_posts"];
        print('Posts found: ${posts.length}');
        
        if (posts.isNotEmpty) {
          // Randomly select a post from the available ones
          final random = math.Random();
          final randomIndex = random.nextInt(posts.length);
          final selectedPost = posts[randomIndex];
          
          print('Selected post at index $randomIndex from ${posts.length} available posts');
          print('Selected post raw data: $selectedPost');
          
          try {
            randomHighlightPost = FeedPostModel.fromJson(selectedPost);
            print('Random highlight post set: ${randomHighlightPost?.description}');
            print('Random highlight post media URL: ${randomHighlightPost?.media.url}');
          } catch (parseError) {
            print('Error parsing FeedPostModel: $parseError');
            print('Post data structure: ${selectedPost.runtimeType}');
            print('Post data keys: ${selectedPost is Map ? (selectedPost as Map).keys.toList() : 'Not a Map'}');
            
            // Fallback: create a simple object with available data
            try {
              final postData = selectedPost as Map<String, dynamic>;
              final mediaData = postData['media'] as Map<String, dynamic>? ?? {};
              
              // Create a minimal working object
              randomHighlightPost = FeedPostModel(
                id: postData['id']?.toString() ?? 'fallback_id',
                userId: postData['user_id']?.toString() ?? 'fallback_user',
                isBookmarked: false,
                isLiked: false,
                description: postData['description']?.toString() ?? 'Weekly Highlight',
                state: postData['state']?.toString() ?? 'active',
                mediaId: postData['media_id']?.toString() ?? 'fallback_media',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                category: postData['category']?.toString() ?? 'general',
                media: Media(
                  id: mediaData['id']?.toString() ?? 'fallback_media_id',
                  ownerId: mediaData['owner_id']?.toString() ?? 'fallback_owner',
                  url: mediaData['url']?.toString() ?? '',
                  fileName: mediaData['file_name']?.toString() ?? 'fallback.jpg',
                  createdAt: DateTime.now(),
                  blurHash: mediaData['blur_hash']?.toString() ?? '',
                ),
              );
              print('Fallback post created successfully');
            } catch (fallbackError) {
              print('Fallback creation also failed: $fallbackError');
              randomHighlightPost = null;
            }
          }
        }
      }
    } catch (e) {
      print('Exception fetching random highlight: $e');
    } finally {
      isLoadingHighlight = false;
      print('Finished fetching, notifying listeners');
      notifyListeners();
    }
  }

  void refreshRandomHighlight(BuildContext context) {
    print('refreshRandomHighlight called');
    randomHighlightPost = null;
    print('randomHighlightPost cleared, calling getRandomHighlight');
    getRandomHighlight(context);
  }

  // Enhanced refresh method that forces new content
  void forceRefreshRandomHighlight(BuildContext context) async {
    print('forceRefreshRandomHighlight called');
    
    // Clear current content first
    randomHighlightPost = null;
    isLoadingHighlight = false;
    notifyListeners();
    
    // Wait a bit to ensure UI updates
    await Future.delayed(Duration(milliseconds: 100));
    
    // Try the alternative method first for better randomness
    tryAlternativeRandomHighlight(context);
    
    // Wait a bit for the alternative method to complete
    await Future.delayed(Duration(milliseconds: 500));
    
    // If alternative method didn't work, fall back to original method
    if (randomHighlightPost == null) {
      print('Alternative method failed, trying original method');
      getRandomHighlight(context);
    }
  }

  // Test method to see what's available
  void testRandomHighlight(BuildContext context) async {
    print('=== TESTING RANDOM HIGHLIGHT ===');
    final client = GraphQLProvider.of(context).value;
    
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final result = await client.query(
        QueryOptions(
          document: gql(getRandomHighlightQuery),
          variables: {
            'timestamp': timestamp,
          },
        ),
      );
      
      print('Test query result: ${result.data}');
      if (result.data != null) {
        final posts = result.data!["feed_get_random_posts"];
        print('Test posts count: ${posts?.length ?? 0}');
        if (posts != null && posts.isNotEmpty) {
          print('=== ALL AVAILABLE POSTS ===');
          for (int i = 0; i < posts.length; i++) {
            final post = posts[i];
            print('Post $i: ID=${post['id']}, Description=${post['description']}, URL=${post['media']?['url']}');
          }
          print('=== END POSTS ===');
        }
      }
    } catch (e) {
      print('Test query error: $e');
    }
  }

  // Method to check if we have different posts
  void checkAvailablePosts(BuildContext context) async {
    print('=== CHECKING AVAILABLE POSTS ===');
    final client = GraphQLProvider.of(context).value;
    
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final result = await client.query(
        QueryOptions(
          document: gql(getRandomHighlightQuery),
          variables: {
            'timestamp': timestamp,
          },
        ),
      );
      
      if (result.data != null) {
        final posts = result.data!["feed_get_random_posts"];
        print('Total posts available: ${posts?.length ?? 0}');
        
        if (posts != null && posts.isNotEmpty) {
          print('=== POST DETAILS ===');
          for (int i = 0; i < posts.length; i++) {
            final post = posts[i];
            final media = post['media'] as Map<String, dynamic>?;
            print('Post $i:');
            print('  ID: ${post['id']}');
            print('  Description: ${post['description']}');
            print('  Category: ${post['category']}');
            print('  Media URL: ${media?['url']}');
            print('  ---');
          }
        }
      }
    } catch (e) {
      print('Check posts error: $e');
    }
  }

  // Try alternative method to get different content
  void tryAlternativeRandomHighlight(BuildContext context) async {
    print('=== TRYING ALTERNATIVE RANDOM METHOD ===');
    final client = GraphQLProvider.of(context).value;
    
    try {
      // First get total count
      final countResult = await client.query(
        QueryOptions(
          document: gql('''
            query GetPostCount {
              feed_posts_aggregate(where: {category: {_is_null: false}}) {
                aggregate {
                  count
                }
              }
            }
          '''),
        ),
      );
      
      int totalPosts = 0;
      if (countResult.data != null) {
        totalPosts = countResult.data!["feed_posts_aggregate"]["aggregate"]["count"] ?? 0;
        print('Total posts in database: $totalPosts');
      }
      
      if (totalPosts > 0) {
        // Generate random offset
        final random = math.Random();
        final randomOffset = random.nextInt(totalPosts);
        print('Using random offset: $randomOffset from $totalPosts total posts');
        
        final result = await client.query(
          QueryOptions(
            document: gql('''
              query GetRandomPost(\$offset: Int!) {
                feed_posts(where: {category: {_is_null: false}}, limit: 1, offset: \$offset) {
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
            '''),
            variables: {
              'offset': randomOffset,
            },
          ),
        );
        
        if (result.data != null) {
          final posts = result.data!["feed_posts"];
          if (posts.isNotEmpty) {
            print('Alternative method got post: ${posts.first}');
            try {
              randomHighlightPost = FeedPostModel.fromJson(posts.first);
              print('Alternative random highlight post set: ${randomHighlightPost?.description}');
              notifyListeners();
            } catch (e) {
              print('Alternative method parsing error: $e');
            }
          }
        }
      }
    } catch (e) {
      print('Alternative method error: $e');
    }
  }
}

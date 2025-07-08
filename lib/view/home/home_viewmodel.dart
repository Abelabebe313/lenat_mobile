import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomeViewModel extends ChangeNotifier {
  List blogs = [];

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
}

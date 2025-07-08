import 'package:flutter/material.dart';
import 'package:lenat_mobile/models/feed_model.dart';
import 'package:lenat_mobile/services/feed_post_service.dart';

class MediaViewModel extends ChangeNotifier {
  final FeedPostService _feedPostService = FeedPostService();
  List<FeedPostModel> _bookmarkedPosts = [];
  bool _isLoading = false;
  String? _error;

  List<FeedPostModel> get bookmarkedPosts => _bookmarkedPosts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBookmarkedPosts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _bookmarkedPosts = await _feedPostService.getBookmarkedFeedPosts();
      
    } catch (e) {
      _error = 'Failed to load bookmarked posts: $e';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
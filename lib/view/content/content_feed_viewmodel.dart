import 'package:flutter/material.dart';
import 'package:lenat_mobile/app/service_locator.dart';
import '../../models/feed_model.dart';
import '../../services/feed_post_service.dart';

class ContentFeedViewModel extends ChangeNotifier {
  final _feedService = locator<FeedPostService>();
  List<FeedPostModel> _posts = [];
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _hasMorePosts = true;

  List<FeedPostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  bool get hasMorePosts => _hasMorePosts;

  Future<void> loadInitialPosts() async {
    if (_isLoading) return;

    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      final newPosts = await _feedService.getFeedPosts();
      _posts = newPosts;
      _hasMorePosts = newPosts.isNotEmpty;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePosts() async {
    if (_isLoading || !_hasMorePosts) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newPosts = await _feedService.getFeedPosts();
      if (newPosts.isEmpty) {
        _hasMorePosts = false;
      } else {
        _posts.addAll(newPosts);
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshPosts() async {
    if (_isRefreshing) return;

    _isRefreshing = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      final newPosts = await _feedService.getFeedPosts(refresh: true);
      _posts = newPosts;
      _hasMorePosts = newPosts.isNotEmpty;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  void retryLoading() {
    if (_posts.isEmpty) {
      loadInitialPosts();
    } else {
      loadMorePosts();
    }
  }
}

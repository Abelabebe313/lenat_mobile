import 'package:flutter/material.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:lenat_mobile/view/content/widget/content_feed_item.dart';
import 'package:lenat_mobile/view/content/content_feed_viewmodel.dart';

class ContentFeedView extends StatefulWidget {
  final String category;
  const ContentFeedView({
    super.key,
    required this.category,
  });

  @override
  State<ContentFeedView> createState() => _ContentFeedViewState();
}

class _ContentFeedViewState extends State<ContentFeedView> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<ContentFeedViewModel>();
      viewModel.setCategory(widget.category);
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isScrolling &&
        context.read<ContentFeedViewModel>().hasMorePosts) {
      _isScrolling = true;
      context.read<ContentFeedViewModel>().loadMorePosts().then((_) {
        _isScrolling = false; // Reset after loading
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<ContentFeedViewModel>(
        builder: (context, viewModel, child) {
          return RefreshIndicator(
            onRefresh: viewModel.refreshPosts,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  floating: false,
                  pinned: true,
                  expandedHeight: 20,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  ),
                  title: Text(
                    widget.category.replaceAll('_', ' '),
                    style: TextStyle(
                      fontFamily: 'NotoSansEthiopic',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (viewModel.isLoading && viewModel.posts.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (viewModel.hasError && viewModel.posts.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${viewModel.errorMessage}',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: viewModel.retryLoading,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (!viewModel.isLoading && viewModel.posts.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.content_paste_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            profileViewModel.isAmharic
                                ? "በዚህ ምድብ ውስጥ ምንም ይዘት የለም"
                                : "No content available in this category",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'NotoSansEthiopic',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: viewModel.refreshPosts,
                            child: Text(
                              profileViewModel.isAmharic ? "አድስ" : "Refresh",
                              style: const TextStyle(
                                fontFamily: 'NotoSansEthiopic',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= viewModel.posts.length) {
                          if (viewModel.isLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (!viewModel.hasMorePosts) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'No more posts to show',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }
                          return null;
                        }

                        final post = viewModel.posts[index];
                        return ContentFeedItem(
                          id: post.id,
                          imageUrl: post.media.url,
                          description: post.description ?? '',
                          blurHash: post.media.blurHash,
                          isLiked: post.isLiked ?? false,
                          isBookmarked: post.isBookmarked ?? false,
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

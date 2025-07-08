import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lenat_mobile/app/service_locator.dart';
import 'package:lenat_mobile/services/feed_post_service.dart';

class ContentFeedItem extends StatefulWidget {
  final String id;
  final String imageUrl;
  final String description;
  final String blurHash;
  final bool isLiked;
  final bool isBookmarked;

  const ContentFeedItem({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.description,
    required this.blurHash,
    required this.isLiked,
    this.isBookmarked = false,
  });

  @override
  State<ContentFeedItem> createState() => _ContentFeedItemState();
}

class _ContentFeedItemState extends State<ContentFeedItem> {
  late bool _isBookmarked;
  late bool _isLiked;
  final _feedService = locator<FeedPostService>();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isBookmarked;
    _isLiked = widget.isLiked;
  }

  Future<void> _toggleBookmark() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      bool success;
      if (_isBookmarked) {
        success = await _feedService.removeBookmark(widget.id);
      } else {
        success = await _feedService.bookmarkPost(widget.id);
      }

      if (success) {
        setState(() {
          _isBookmarked = !_isBookmarked;
        });
      }
    } catch (e) {
      print('Error toggling bookmark: $e');
      // Show error message if needed
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.6,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => widget.blurHash.isNotEmpty
                      ? BlurHash(hash: widget.blurHash)
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withOpacity(0.8),
                      child: IconButton(
                        onPressed: () {},
                        icon: _isLiked
                            ? Icon(
                                Icons.favorite_rounded,
                                color: Colors.red,
                                size: 24.0,
                              )
                            : HugeIcon(
                                icon: HugeIcons.strokeRoundedFavourite,
                                color: Colors.red,
                                size: 24.0,
                              ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withOpacity(0.8),
                      child: IconButton(
                        onPressed: _isProcessing ? null : _toggleBookmark,
                        icon: _isProcessing
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : _isBookmarked
                                ? Icon(
                                    Icons.bookmark,
                                    color: Colors.deepOrange,
                                    size: 24.0,
                                  )
                                : HugeIcon(
                                    icon: HugeIcons.strokeRoundedBookmark02,
                                    color: Colors.black,
                                    size: 24.0,
                                  ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withOpacity(0.8),
                      child: IconButton(
                        onPressed: () {},
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedDownload02,
                          color: Colors.black,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

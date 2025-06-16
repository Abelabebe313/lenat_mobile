import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ContentFeedItem extends StatelessWidget {
  final String imageUrl;
  final String description;
  final String blurHash;

  const ContentFeedItem({
    super.key,
    required this.imageUrl,
    required this.description,
    required this.blurHash,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.6,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => blurHash.isNotEmpty
                      ? BlurHash(hash: blurHash)
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
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "A new life begins! In the first month, your baby is settling into the womb, starting an incredible journey of growth.",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
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
                            icon: HugeIcon(
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
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                ),
                                builder: (context) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text('Comment dropdown goes here'),
                                  );
                                },
                              );
                            },
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedComment02,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/content/content_feed_view.dart';
import 'package:lenat_mobile/view/media/media_viewmodel.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class MediaView extends StatefulWidget {
  const MediaView({super.key});

  @override
  State<MediaView> createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    final mediaViewModel = Provider.of<MediaViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          profileViewModel.isAmharic ? "ሚድያ" : "Content",
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'NotoSansEthiopic',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          const SizedBox(width: 16),
          HugeIcon(
            icon: HugeIcons.strokeRoundedNotification02,
            color: Colors.black,
            size: 24.0,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mediaViewModel.mediaCategories.length,
                  itemBuilder: (context, index) {
                    return _mediaCatagotyCard(
                        mediaViewModel.mediaCategories[index]);
                  },
                ),
              ),
              const SizedBox(height: 32),
              Text(
                profileViewModel.isAmharic
                    ? "ትምህርታዊ ጥያቄዎች"
                    : "Trivia Questions",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
              const SizedBox(height: 16),
              _buildTriviaCard(
                profileViewModel,
              ),
              const SizedBox(height: 16),
              Text(
                profileViewModel.isAmharic
                    ? "የተወዳጅ ወይም የተመዘገበ ሚድያ"
                    : "Liked or Bookmarked Content",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/content_feed');
                      },
                      child: _mediaFavoriteCard(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTriviaCard(
    ProfileViewModel profileViewModel,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('assets/images/weekly_trivia.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profileViewModel.isAmharic ? "የሳምንቱ 8 ጥያቄዎች" : "Week 8 Trivia",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansEthiopic',
                  fontSize: 14,
                ),
              ),
              const Text(
                'lorem ipsum dolor sit amet,',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/trivia');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 36,
                  ),
                ),
                child: Text(
                  profileViewModel.isAmharic ? "ጨዋታ ጀምር" : "Let's Play",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mediaCatagotyCard(Map<String, String> category) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/content_feed');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContentFeedView(
              category: category['title'] ?? "Content Feed",
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Color(0xFFFBFBFB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  category['image'] ?? 'assets/images/default.png',
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                    width: 140,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFD5E5F7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        category['title'] ?? 'Unknown',
                        style: TextStyle(
                          color: Primary,
                          fontFamily: 'NotoSansEthiopic',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mediaFavoriteCard() {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/login-image.png',
            fit: BoxFit.cover,
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}

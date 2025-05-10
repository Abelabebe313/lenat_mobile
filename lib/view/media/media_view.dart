import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';

class MediaView extends StatefulWidget {
  const MediaView({super.key});

  @override
  State<MediaView> createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'ሚድያ',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'NotoSansEthiopic',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedBookmark02,
            color: Colors.black,
            size: 24.0,
          ),
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
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return _mediaCatagotyCard();
                  },
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "ትምህርታዊ ጥያቄዎች",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
              const SizedBox(height: 16),
              _buildTriviaCard(),
              const SizedBox(height: 16),
              const Text(
                "የተወዳጅ ወይም የተመዘገበ ሚድያ",
                style: TextStyle(
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
                    return _mediaFavoriteCard();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTriviaCard() {
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
              const Text(
                'የሳምንቱ 8 ጥያቄዎች',
                style: TextStyle(
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
                  "ጨዋታ ጀምር",
                  style: TextStyle(
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

  Widget _mediaCatagotyCard() {
    return Container(
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
                'assets/images/login-image.png',
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFD5E5F7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'የመጀመሪያ ወር',
                  style: TextStyle(
                    color: Primary,
                    fontFamily: 'NotoSansEthiopic',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
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

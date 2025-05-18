import 'package:flutter/material.dart';
import 'package:lenat_mobile/view/content/widget/content_feed_item.dart';

class ContentFeedView extends StatefulWidget {
  const ContentFeedView({super.key});

  @override
  State<ContentFeedView> createState() => _ContentFeedViewState();
}

class _ContentFeedViewState extends State<ContentFeedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
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
            title: const Text(
              "ወደ ኋላ ይመለሱ",
              style: TextStyle(
                fontFamily: 'NotoSansEthiopic',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          /// Section Title — “ሚድያ”
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Text(
                "ሚድያ",
                style: TextStyle(
                  fontFamily: 'NotoSansEthiopic',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          /// Content Feed List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return const ContentFeedItem(
                  imageUrl:
                      "https://images.unsplash.com/photo-1538678867871-8a43e7487746?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  description:
                      "A new life begins! In the first month, your baby is settling into the womb, starting an incredible journey of growth.",
                );
              },
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}

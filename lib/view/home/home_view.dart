import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/home/home_viewmodel.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:lenat_mobile/view/home/widget/premium_content_container.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().getBlogs(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              const SizedBox(height: 10.0),
              // =============  Header ==============
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.115,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: RichText(
                              text: TextSpan(
                            text: profileViewModel.isAmharic ? "ሰላም\n" : "Hello\n",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontFamily: 'NotoSansEthiopic',
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                            ),
                            children: [
                              TextSpan(
                                text: profileViewModel.currentUser?.fullName ??
                                    '',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  fontSize: 28.0,
                                ),
                              ),
                            ],
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/notifications');
                          },
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedNotification02,
                            color: Colors.black,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 24,
                    child: Container(
                      width: 110.0,
                      height: 40.0,
                      transform: Matrix4.rotationZ(-0.1),
                      decoration: BoxDecoration(
                        color: Color(0xFFD5E5F7),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Text(
                          profileViewModel.isAmharic ? "ሳምንቱ 10" : "Week 10",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16.0,
                            color: Primary,
                            fontFamily: 'NotoSansEthiopic',
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),

              // =============  weekly ==============
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Row(
                  spacing: 10.0,
                  children: [
                    Text(
                      profileViewModel.isAmharic ? "የሳምንቱ ዋነኛ ነገር" : "Weekly Highlights",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Transform.rotate(
                      angle: math.pi / 0.7,
                      child: Icon(
                        Icons.subdirectory_arrow_left_rounded,
                        size: 28.0,
                        color: Primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  spacing: 10.0,
                  children: [
                    Container(
                      width: 150.0,
                      height: 180.0,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Image.asset(
                        'assets/images/image.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 190.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "abc",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            "Lorem ipsum dolor sit amet consectetur. Sagittis id libero.Lorem ipsum dolor sit amet consectetur. Sagittis id libero.",
                          ),
                          ElevatedButton(
                            onPressed: () {},
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
                              "ተጨማሪ ያንብቡ",
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
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileViewModel.isAmharic ? "መዝገብ" : "Book",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              profileViewModel.isAmharic ? "ከእኛ ጋር የግል ምክር ለማግኘት የተለያዩ ባለሞያዎች ጋር የተወሰነ ቀን ይዘው ይግቡ።" : "Book an appointment with our experts to get personalized advice.",
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ElevatedButton(
                              onPressed: () {},
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
                                profileViewModel.isAmharic ? "ቀጠሮ ያዝ" : "Book",
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
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        width: 200.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileViewModel.isAmharic ? "መማር" : "Learn",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              profileViewModel.isAmharic ? "ለእርሶ የተመረጡ ትምርታዊ ጥያቄዎች ይጫወቱ: አዲስ እውቀት ይጨብጡ" : "Play our trivia game to test your knowledge and learn new things.",
                            ),
                            SizedBox(
                              height: 10.0,
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
                                profileViewModel.isAmharic ? "ጨዋታ ጀመር" : "Play",
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
                      ),
                    ),
                  ),
                ],
              ),

              // Premium Content
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  bottom: 10.0,
                  top: 15.0,
                ),
                child: Text(
                  "ለእርሶ የተመረጡ ልዩ መረጃዎች",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),

              Container(
                height: 240.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: viewModel.blogs.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(5.0),
                  itemBuilder: (context, index) => PremiumContentContainer(
                    image: viewModel.blogs[index]["media"]["url"],
                    title: viewModel.blogs[index]["title"],
                    content: viewModel.blogs[index]["content"],
                  ),
                ),
              ),
              SizedBox(height: 200.0),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFF9747FF),
            onPressed: () {
              Navigator.pushNamed(context, "/ai_chat");
            },
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedRobotic,
              color: Colors.white,
              size: 32.0,
            ),
          ),
        );
      },
    );
  }
}

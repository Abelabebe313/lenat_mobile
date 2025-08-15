import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/home/home_viewmodel.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:lenat_mobile/view/home/widget/premium_content_container.dart';
import 'package:lenat_mobile/view/home/widget/full_screen_image_modal.dart';
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
      context.read<HomeViewModel>().getRandomHighlight(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: () async {
              print('Pull-to-refresh triggered');
              context.read<HomeViewModel>().getBlogs(context);
              context.read<HomeViewModel>().forceRefreshRandomHighlight(context);
            },
            child: ListView(
              children: [
              const SizedBox(height: 10.0),
              // =============  Header ==============
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.13,
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
                          "${profileViewModel.currentUser?.pregnancyPeriod.toString()}ኛ ወር" ?? 'የእርግዝና ወር',
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
                      profileViewModel.isAmharic ? "የሳምንቱ ዋና መልእክት" : "Weekly Highlights",
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
              if (viewModel.isLoadingHighlight)
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
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Primary,
                          ),
                        ),
                      ),
                      Container(
                        width: 190.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 20.0,
                              width: 120.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              height: 40.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              else if (viewModel.randomHighlightPost != null)
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
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => FullScreenImageModal(
                              imageUrl: viewModel.randomHighlightPost!.media.url.isNotEmpty
                                  ? viewModel.randomHighlightPost!.media.url
                                  : 'assets/images/image.png',
                              title: viewModel.randomHighlightPost!.description?.isNotEmpty == true
                                  ? viewModel.randomHighlightPost!.description!
                                  : (profileViewModel.isAmharic ? "የሳምንቱ ዋና መልእክት" : "Weekly Highlight"),
                            ),
                          );
                        },
                        child: Container(
                          width: 150.0,
                          height: 180.0,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: viewModel.randomHighlightPost!.media.url.isNotEmpty
                              ? Image.network(
                                  viewModel.randomHighlightPost!.media.url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Image.asset(
                                    'assets/images/image.png',
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/image.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Container(
                        width: 190.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viewModel.randomHighlightPost!.description?.isNotEmpty == true
                                  ? viewModel.randomHighlightPost!.description!
                                  : (profileViewModel.isAmharic ? "የሳምንቱ ዋና መልእክት" : "Weekly Highlight"),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              profileViewModel.isAmharic 
                                  ? "የተለያዩ ጥልቀት ያላቸው መረጃዎችን ለማየት ይህን ይጫኑ"
                                  : "Tap to discover new and different content for your pregnancy journey",
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: () {
                                print('Refresh button pressed');
                                // Refresh to get a new random highlight
                                context.read<HomeViewModel>().forceRefreshRandomHighlight(context);
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
                                profileViewModel.isAmharic ? "አድስ" : "Refresh",
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
                )
              else
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
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => FullScreenImageModal(
                              imageUrl: 'assets/images/image.png',
                              title: profileViewModel.isAmharic ? "የሳምንቱ ዋና መልእክት" : "Weekly Highlight",
                            ),
                          );
                        },
                        child: Container(
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
                      ),
                      Container(
                        width: 190.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileViewModel.isAmharic ? "የሳምንቱ ዋና መልእክት" : "Weekly Highlight",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              profileViewModel.isAmharic 
                                  ? "የተለያዩ ጥልቀት ያላቸው መረጃዎችን ለማየት ይህን ይጫኑ"
                                  : "Tap to discover new and different content for your pregnancy journey",
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print('Fallback refresh button pressed');
                                context.read<HomeViewModel>().forceRefreshRandomHighlight(context);
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
                                profileViewModel.isAmharic ? "አድስ" : "Refresh",
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
                              profileViewModel.isAmharic ? "የማማከር አገልግሎት" : "Book",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              profileViewModel.isAmharic ? "ሀኪሞትን በተመቾት ሰዓት እና ቀን ለማማከር ቀጠሮ ይያዙ።" : "Book an appointment with our experts to get personalized advice.",
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
                              profileViewModel.isAmharic ? "ትምርታዊ ጥያቄዎች" : "Educational Trivia",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              profileViewModel.isAmharic ? "የተመረጡ ጥያቄዎችን በመመለስ ስለእርግዝና ያሎትን እውቀት ይፈትሹ!" : "Play our trivia game to test your knowledge and learn new things.",
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

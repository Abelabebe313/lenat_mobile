import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/home/home_viewmodel.dart';
import 'package:lenat_mobile/view/home/widget/premium_content_container.dart';
import 'package:lenat_mobile/app/service_locator.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isFemale = true;

  void getUser() async {
    final _authService = locator<AuthService>();
    final currentUser = await _authService.getCurrentUser();
    isFemale = currentUser!.gender! == "female";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().getBlogs(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              isFemale ? 'እንደምን አደርሽ' : "እንደምን አደርክ",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'NotoSansEthiopic',
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/notifications');
                },
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedNotification02,
                  color: Colors.black,
                  size: 24.0,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: ListView(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  bottom: 10.0,
                  top: 15.0,
                ),
                child: Text(
                  "የሳምንቱ ዋነኛ ነገር",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
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
                      width: 200.0,
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
                              "abc",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              "Lorem ipsum dolor sit amet consectetur. Sagittis id libero.Lorem ipsum dolor sit amet consectetur. Sagittis id libero.",
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
                              "abc",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              "Lorem ipsum dolor sit amet consectetur. Sagittis id libero.Lorem ipsum dolor sit amet consectetur. Sagittis id libero.",
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
            backgroundColor: Primary,
            onPressed: () {
              Navigator.pushNamed(context, "/ai_chat");
            },
            child: Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

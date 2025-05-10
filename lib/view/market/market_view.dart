import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/market/product_detail_page.dart';
import 'package:lenat_mobile/view/market/widgets/market_item_widget.dart';

class MarketView extends StatefulWidget {
  const MarketView({super.key});

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> {
  List<Map<String, dynamic>> categoryList = [
    {
      "label": "የነፍሰ ጡር ልብስ",
      "icon": HugeIcon(
        icon: HugeIcons.strokeRoundedClothes,
        color: Primary,
        size: 30.0,
      ),
    },
    {
      "label": "የህፃናት ልብስ",
      "icon": HugeIcon(
        icon: HugeIcons.strokeRoundedBaby01,
        color: Primary,
        size: 30.0,
      ),
    },
    {
      "label": "መጫወቻዎች",
      "icon": HugeIcon(
        icon: HugeIcons.strokeRoundedToyTrain,
        color: Primary,
        size: 30.0,
      ),
    },
    {
      "label": "ስጦታዎች",
      "icon": HugeIcon(
        icon: HugeIcons.strokeRoundedGift,
        color: Primary,
        size: 30.0,
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "ገበያ",
          style: TextStyle(
            fontFamily: 'NotoSansEthiopic',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedShoppingCart01,
              color: Colors.black,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                "Lorem ipsum dolor sit amet consectetur. Velit mauris etiam tortor adipiscing dis.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Search ...",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFDFDFDF),
                      fontFamily: 'NotoSansEthiopic',
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        color: Color(0xFFDFDFDF),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        color: Color(0xFFDFDFDF),
                        width: 1,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // Add your search action here
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/dress1.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "አዲስ የገቡ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "የነፍሰ ጡር ልብስ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "2,500 ብር",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "አሁን ይግዙ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    final category = categoryList[index];
                    final label = category["label"] ?? "";
                    final icon = category["icon"];

                    return GestureDetector(
                      onTap: () {
                        print('Tapped category: $label');
                        // TODO: Navigate or filter items
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F6FB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(child: icon),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              label,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "የተመረጡ እቃዎች",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // MarketItemWidget(),
              // create me Grid view with 2 item in each row
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductDetailPage(),
                        ),
                      );
                    },
                    child: const MarketItemWidget(),
                  );
                },
              ),
              const SizedBox(height: 400),
            ],
          ),
        ),
      ),
    );
  }
}

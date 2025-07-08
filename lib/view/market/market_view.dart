import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:provider/provider.dart';

import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/market/market_viewmodel.dart';
import 'package:lenat_mobile/view/market/product_detail_page.dart';
import 'package:lenat_mobile/view/market/widgets/market_item_widget.dart';

class MarketView extends StatefulWidget {
  const MarketView({super.key});

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> {
  // Map of category names to their icons
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = context.read<MarketViewModel>();
      try {
        // Try to load products with proper error handling
        await viewModel.loadFeaturedProducts();
      } catch (e) {
        print('Error loading products in initState: $e');
        // If there's an error on first load, we'll retry once
        if (mounted) {
          await Future.delayed(const Duration(milliseconds: 500));
          viewModel.loadFeaturedProducts();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    final marketViewModel = Provider.of<MarketViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        centerTitle: true,
        elevation: 0,
        title: Text(
          profileViewModel.isAmharic ? "ገበያ" : "Market",
          style: const TextStyle(
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
      body: RefreshIndicator(
        onRefresh: () async {
          await marketViewModel.refreshFeaturedProducts();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  profileViewModel.isAmharic
                      ? "የተመረጡ እቃዎች የእናቶች እና የህፃናት ልብስ መጫወቻዎች እና ስጦታዎች የመጠባበቅ መስመር ነው።"
                      : "Lorem ipsum dolor sit amet consectetur. Velit mauris etiam tortor adipiscing dis.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                        child: Center(
                          child: Text(
                            profileViewModel.isAmharic
                                ? "አዲስ የገቡ"
                                : "New Arrivals",
                            style: const TextStyle(
                              fontSize: 12,
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
                                    profileViewModel.isAmharic
                                        ? "የነፍሰ ጡር ልብስ"
                                        : 'Pregnancy cloths',
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
                                child: Center(
                                  child: Text(
                                    profileViewModel.isAmharic
                                        ? "አሁን ይግዙ"
                                        : "Buy Now",
                                    style: TextStyle(
                                      fontSize: 14,
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
                  profileViewModel.isAmharic
                      ? "የተመረጡ እቃዎች"
                      : "Featured Products",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                if (marketViewModel.isLoading &&
                    marketViewModel.featuredProducts.isEmpty)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (marketViewModel.hasError)
                  Center(
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text(
                          'Failed to load products',
                          style: TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () =>
                              marketViewModel.loadFeaturedProducts(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                else if (marketViewModel.featuredProducts.isEmpty)
                  const Center(
                    child: Text('No featured products available'),
                  )
                else
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: marketViewModel.featuredProducts.length,
                    itemBuilder: (context, index) {
                      final product = marketViewModel.featuredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductDetailPage(),
                            ),
                          );
                        },
                        child: MarketItemWidget(product: product),
                      );
                    },
                  ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

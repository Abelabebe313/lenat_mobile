import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/view/market/cart/cart_viewmodel.dart';
import 'package:lenat_mobile/view/market/widgets/product_listing_view.dart';
import 'package:lenat_mobile/view/market/widgets/search_results_view.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:provider/provider.dart';

import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/market/market_viewmodel.dart';
import 'package:lenat_mobile/view/market/widgets/product_detail_page.dart';
import 'package:lenat_mobile/view/market/widgets/market_item_widget.dart';

class MarketView extends StatefulWidget {
  const MarketView({super.key});

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<MarketViewModel>();
      viewModel.loadFeaturedProducts();
      viewModel.loadMarketPlaceCatagory();

      // Also load cart items to update badge
      final cartViewModel = context.read<CartViewModel>();
      cartViewModel.loadCart();
    });
  }

  Widget _buildSearchBar(
      MarketViewModel marketViewModel, ProfileViewModel profileViewModel) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: SizedBox(
        height: 50,
        child: TextFormField(
          controller: marketViewModel.searchController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: profileViewModel.isAmharic ? "ፈልግ ..." : "Search ...",
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
                marketViewModel
                    .searchProducts(marketViewModel.searchController.text);
                if (marketViewModel.searchController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResultsView(
                        searchQuery: marketViewModel.searchController.text,
                        searchResults: marketViewModel.searchResults,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    final marketViewModel = Provider.of<MarketViewModel>(context);
    final newArrival = marketViewModel.featuredProducts.last;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: RefreshIndicator(
        onRefresh: () async {
          await marketViewModel.refreshFeaturedProducts();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.grey.shade50,
              centerTitle: true,
              elevation: 0,
              pinned: true,
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
                Consumer<CartViewModel>(
                  builder: (context, cartViewModel, child) {
                    return Stack(
                      children: [
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
                        if (!cartViewModel.isEmpty)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '${cartViewModel.cartItems.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickySearchBarDelegate(
                child: _buildSearchBar(marketViewModel, profileViewModel),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                            child: marketViewModel.featuredProducts.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: newArrival
                                            .productImages.last.medium.url ??
                                        '',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 120,
                                    placeholder: (context, url) => newArrival
                                            .mainImageBlurHash.isNotEmpty
                                        ? BlurHash(
                                            hash: newArrival.mainImageBlurHash)
                                        : Container(
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(Icons.error),
                                      ),
                                    ),
                                  )
                                : Image.asset(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        newArrival.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        profileViewModel.isAmharic
                                            ? "${newArrival.price} ብር"
                                            : "${newArrival.price} Birr",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailPage(
                                                  product: newArrival),
                                        ),
                                      );
                                    },
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
                                              ? "ይዘዙ"
                                              : "Buy Now",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
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
                    Text(
                      profileViewModel.isAmharic ? "አይነት" : "Categories",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: marketViewModel.marketCatagory.length,
                        itemBuilder: (context, index) {
                          final category =
                              marketViewModel.marketCatagory[index];
                          final label = category;
                          // final icon = category["icon"];
                          return GestureDetector(
                            onTap: () {
                              print('Tapped category: $label');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductListingView(
                                    category: label,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF2F6FB),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        label.name ?? '',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      profileViewModel.isAmharic
                          ? "ለእርሶ የተመረጡ እቃዎች"
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
                      const Center(child: CircularProgressIndicator())
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
                          final product =
                              marketViewModel.featuredProducts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailPage(product: product),
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
          ],
        ),
      ),
    );
  }
}

class _StickySearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickySearchBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 66.0; // Height of search bar + padding

  @override
  double get minExtent => 66.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

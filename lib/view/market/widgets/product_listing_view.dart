import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/view/market/cart/cart_viewmodel.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:provider/provider.dart';

import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/market/market_viewmodel.dart';
import 'package:lenat_mobile/view/market/widgets/product_detail_page.dart';
import 'package:lenat_mobile/view/market/widgets/market_item_widget.dart';

import '../../../models/catagory_model.dart';

class ProductListingView extends StatefulWidget {
  final CategoryModel category;
  const ProductListingView({super.key, required this.category});

  @override
  State<ProductListingView> createState() => _ProductListingViewState();
}

class _ProductListingViewState extends State<ProductListingView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<MarketViewModel>();
      viewModel.loadProductsByCategory(widget.category);

      // Also load cart items to update badge
      final cartViewModel = context.read<CartViewModel>();
      cartViewModel.loadCart();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    final marketViewModel = Provider.of<MarketViewModel>(context);

    // Filter products based on search query
    final filteredProducts = _searchQuery.isEmpty
        ? marketViewModel.productsByCategory
        : marketViewModel.productsByCategory.where((product) {
            final name = product.name?.toLowerCase() ?? '';
            final description = product.description?.toLowerCase() ?? '';
            return name.contains(_searchQuery.toLowerCase()) ||
                description.contains(_searchQuery.toLowerCase());
          }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.category.name ?? '',
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
      body: RefreshIndicator(
        onRefresh: () async {
          await marketViewModel.refreshProductsByCategory(widget.category);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    keyboardType: TextInputType.text,
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
                          // Search happens automatically on text change
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (marketViewModel.isLoading &&
                    marketViewModel.productsByCategory.isEmpty)
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
                          onPressed: () => marketViewModel
                              .loadProductsByCategory(widget.category),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                else if (filteredProducts.isEmpty)
                  Center(
                    child: Text(_searchQuery.isEmpty
                        ? 'No products available'
                        : 'No products found for "$_searchQuery"'),
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
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
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
      ),
    );
  }
}

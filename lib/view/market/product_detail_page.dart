import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/app/service_locator.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/models/market_product_model.dart';
import 'package:lenat_mobile/services/cart_service.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final MarketPlaceModel product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int? selectedSizeIndex;
  int? selectedColorIndex;
  bool isDescriptionExpanded = false;
  final CartService _cartService = locator<CartService>();
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    // Initialize selected indices only if variants are available
    if (widget.product.variants.size != null &&
        widget.product.variants.size!.isNotEmpty) {
      selectedSizeIndex = 0;
    }
    if (widget.product.variants.color != null &&
        widget.product.variants.color!.isNotEmpty) {
      selectedColorIndex = 0;
    }

    // Debug print to see the variants data
    print('Size variants: ${widget.product.variants.size}');
    print('Color variants: ${widget.product.variants.color}');
  }

  // Get selected size
  String? get selectedSize {
    if (selectedSizeIndex == null ||
        widget.product.variants.size == null ||
        widget.product.variants.size!.isEmpty) {
      return null;
    }
    return widget.product.variants.size![selectedSizeIndex!];
  }

  // Get selected color
  String? get selectedColor {
    if (selectedColorIndex == null ||
        widget.product.variants.color == null ||
        widget.product.variants.color!.isEmpty) {
      return null;
    }
    return widget.product.variants.color![selectedColorIndex!];
  }

  // Add to cart
  Future<void> _addToCart() async {
    setState(() {
      _isAddingToCart = true;
    });

    try {
      await _cartService.addToCart(
        widget.product,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('ምርት ወደ ግብይት ዕቃ ተጨምሯል'),
          action: SnackBarAction(
            label: 'ወደ ግብይት ዕቃ',
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding to cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isAddingToCart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ወደ ኋላ ይመለሱ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'NotoSansEthiopic',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Text(
                  profileViewModel.isAmharic ? 'የምርቱ ዝርዝር' : 'Product Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'NotoSansEthiopic',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: widget.product.productImages.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl:
                                  widget.product.productImages[0].medium.url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: Icon(Icons.image_not_supported, size: 50),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFFD3D5D4CC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedFavourite,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  if (widget.product.productImages.length > 1)
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.product.productImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.product
                                        .productImages[index].medium.url,
                                    fit: BoxFit.cover,
                                    width: 80,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[200],
                                      child: Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.grey[200],
                                      child: Icon(Icons.error, size: 20),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.product.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                  ),
                ],
              ),
              // Description
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.description,
                    maxLines: isDescriptionExpanded ? null : 2,
                    overflow: isDescriptionExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isDescriptionExpanded = !isDescriptionExpanded;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      isDescriptionExpanded ? "Read Less" : "Read More",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),

              // Size Selection - Only show if sizes are available
              if (widget.product.variants.size != null &&
                  widget.product.variants.size!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      "ልብስ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 16,
                        alignment: WrapAlignment.start,
                        runSpacing: 12,
                        children: List.generate(
                            widget.product.variants.size!.length, (index) {
                          final isSelected = selectedSizeIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedSizeIndex = index;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade400,
                                ),
                              ),
                              child: Text(
                                widget.product.variants.size![index],
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'NotoSansEthiopic',
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),

              // Color Selection - Only show if colors are available
              if (widget.product.variants.color != null &&
                  widget.product.variants.color!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      "ቀለም ይምረጡ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 16,
                        alignment: WrapAlignment.start,
                        runSpacing: 12,
                        children: List.generate(
                            widget.product.variants.color!.length, (index) {
                          final isSelected = selectedColorIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColorIndex = index;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade400,
                                ),
                              ),
                              child: Text(
                                widget.product.variants.color![index],
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'NotoSansEthiopic',
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileViewModel.isAmharic ? "ጠቅላላ ዋጋ" : "Total Price",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
                Text(
                  "${widget.product.price} ብር",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
              ],
            ),
            Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                color: Primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                onPressed: _isAddingToCart ? null : _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isAddingToCart
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        profileViewModel.isAmharic ? "አሁን ይግዙ" : "Buy Now",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'NotoSansEthiopic',
                        ),
                      ),
              ),
            ),
            Container(
              height: 40,
              width: 50,
              decoration: BoxDecoration(
                color: Color(0xFFD5E5F7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_bag,
                  color: Primary,
                  size: 24,
                ),
                onPressed: _isAddingToCart ? null : _addToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

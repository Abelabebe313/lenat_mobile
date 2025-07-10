import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/models/cart_model.dart';
import 'package:lenat_mobile/view/market/cart/cart_viewmodel.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    // Load cart items when the view initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartViewModel>(context, listen: false).loadCart();
    });
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
        title: Text(
          profileViewModel.isAmharic ? 'ወደ ኋላ ይመለሱ' : 'Back',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'NotoSansEthiopic',
          ),
        ),
        actions: [
          Consumer<CartViewModel>(
            builder: (context, viewModel, child) {
              return !viewModel.isEmpty
                  ? IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _showClearCartDialog(context),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<CartViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.loadCart(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (viewModel.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'የግብይት ዕቃዎ ባዶ ነው',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ለመግዛት ወደ ገበያ ይመለሱ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'ወደ ገበያ ይሂዱ',
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
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    profileViewModel.isAmharic ? 'የመረጡት እቃ' : 'Cart',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'NotoSansEthiopic',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: viewModel.cartItems.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildCartItem(
                            viewModel,
                            viewModel.cartItems[index],
                            index,
                            profileViewModel,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Consumer<CartViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.2,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(height: 10),
                buildPriceRow(profileViewModel.isAmharic ? "ንዑስ ገንዘብ" : "Subtotal", "${viewModel.totals.subtotal} ብር"),
                buildPriceRow(profileViewModel.isAmharic ? "ዴሊቨሪ" : "Delivery Fee", "${viewModel.totals.deliveryFee} ብር"),
                buildPriceRow(profileViewModel.isAmharic ? "ጠቅላላ ዋጋ" : "Total", "${viewModel.totals.total} ብር"),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/checkout');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      profileViewModel.isAmharic ? "ወደ ትዕዛዝ ይቀጥሉ" : "Proceed to Checkout",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartItem(
      CartViewModel viewModel, CartItemModel item, int index, ProfileViewModel profileViewModel) {
    return Dismissible(
      key: Key(item.productId + (item.size ?? '') + (item.color ?? '')),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmationDialog(context);
      },
      onDismissed: (direction) {
        viewModel.removeItem(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(profileViewModel.isAmharic ? 'ምርት ከግብይት ዕቃ ተወግዷል' : 'Item removed from cart'),
            action: SnackBarAction(
              label: profileViewModel.isAmharic ? 'ቀልብስ' : 'Undo',
              onPressed: () {
                // Implement undo functionality if needed
                viewModel.loadCart();
              },
            ),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: item.imageUrl.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/dress1.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    item.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSansEthiopic',
                    fontSize: 14,
                  ),
                ),
                if (item.size != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    profileViewModel.isAmharic ? 'ልኬት፡ ${item.size}' : 'Size: ${item.size}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                ],
                // if (item.color != null) ...[
                //   const SizedBox(height: 4),
                //   Text(
                //     'ቀለም፡ ${item.color}',
                //     style: TextStyle(
                //       fontSize: 12,
                //       color: Colors.grey.shade600,
                //       fontFamily: 'NotoSansEthiopic',
                //     ),
                //   ),
                // ],
                const SizedBox(height: 8),
                Text(
                  '${item.price} ብር',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              _quantityButton(
                icon: Icons.remove,
                color: Colors.grey.shade300,
                onPressed: () => viewModel.decreaseQuantity(index),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  item.quantity.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              _quantityButton(
                icon: Icons.add,
                color: Colors.blue,
                onPressed: () => viewModel.increaseQuantity(index),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color == Colors.blue ? Colors.white : Colors.black,
          size: 18,
        ),
      ),
    );
  }

  Widget buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontFamily: 'NotoSansEthiopic',
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: 'NotoSansEthiopic',
          ),
        ),
      ],
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'ምርት ማስወገድ',
              style: TextStyle(fontFamily: 'NotoSansEthiopic'),
            ),
            content: const Text(
              'ይህን ምርት ከግብይት ዕቃ ማስወገድ ትፈልጋለህ?',
              style: TextStyle(fontFamily: 'NotoSansEthiopic'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'አይ',
                  style: TextStyle(fontFamily: 'NotoSansEthiopic'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'አዎ',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _showClearCartDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'ግብይት ዕቃ ማጽዳት',
              style: TextStyle(fontFamily: 'NotoSansEthiopic'),
            ),
            content: const Text(
              'ሁሉንም ምርቶች ከግብይት ዕቃ ማስወገድ ትፈልጋለህ?',
              style: TextStyle(fontFamily: 'NotoSansEthiopic'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'አይ',
                  style: TextStyle(fontFamily: 'NotoSansEthiopic'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'አዎ',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed) {
      final viewModel = Provider.of<CartViewModel>(context, listen: false);
      viewModel.clearCart();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ግብይት ዕቃ ተጽድቷል'),
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final List<CartItem> cartItems = [
    CartItem(
      imageUrl: 'assets/images/dress1.png',
      title: 'የማቅረብ ልብስ',
      size: 'XL',
      price: 2500,
      quantity: 12,
    ),
    CartItem(
      imageUrl: 'assets/images/dress1.png',
      title: 'የማቅረብ ልብስ',
      size: 'XL',
      price: 2000,
      quantity: 15,
    ),
    CartItem(
      imageUrl: 'assets/images/dress1.png',
      title: 'የማቅረብ ልብስ',
      size: 'XL',
      price: 1800,
      quantity: 20,
    ),
  ];

  void increaseQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const Text(
                'የእኔ ግብይት',
                style: TextStyle(
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
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildCartItem(
                        cartItems[index],
                        index,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
            buildPriceRow("ንዑስ ገንዘብ", "40,500 ብር"),
            buildPriceRow("ዴሊቨሪ", "200 Br/KM"),
            buildPriceRow("ጠቅላላ ዋጋ", "40,700 Br"),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  "ወደ ትዕዛዝ ይቀጥሉ",
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
      ),
    );
  }

  Widget _buildCartItem(CartItem item, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansEthiopic',
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ስይም፡ ${item.size}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${item.price} Br',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Row(
          spacing: 8,
          children: [
            _quantityButton(
              icon: Icons.remove,
              color: Colors.grey.shade300,
              onPressed: () => decreaseQuantity(index),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
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
              onPressed: () => increaseQuantity(index),
            ),
          ],
        )
      ],
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
}

class CartItem {
  final String imageUrl;
  final String title;
  final String size;
  final int price;
  int quantity;

  CartItem({
    required this.imageUrl,
    required this.title,
    required this.size,
    required this.price,
    required this.quantity,
  });
}

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/models/cart_model.dart';
import 'package:lenat_mobile/view/cart/cart_view.dart';
import 'package:lenat_mobile/view/checkout/widget/payment_success_popups.dart';

class CheckOutView extends StatefulWidget {
  const CheckOutView({super.key});

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  String selectedPaymentMethod = 'cash';
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final List<CartItemModel> cartItems = [
    CartItemModel(
      imageUrl: 'assets/images/dress1.png',
      title: 'የማቅረብ ልብስ',
      size: 'XL',
      price: 2500,
      quantity: 12,
    ),
    CartItemModel(
      imageUrl: 'assets/images/dress1.png',
      title: 'የማቅረብ ልብስ',
      size: 'XL',
      price: 2000,
      quantity: 15,
    ),
    CartItemModel(
      imageUrl: 'assets/images/dress1.png',
      title: 'የማቅረብ ልብስ',
      size: 'XL',
      price: 1800,
      quantity: 20,
    ),
  ];

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'የትኬት ዝርዝር',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'NotoSansEthiopic',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'ሁሉንም ይመልከቱ',
                    style: TextStyle(
                      color: Primary,
                      fontSize: 14,
                      fontFamily: 'NotoSansEthiopic',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
                      child: _buildCheckOutItem(
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
        height: MediaQuery.of(context).size.height * 0.45,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildPaymentMethodSelection(),
                  _buildPhoneField(),
                  _buildAddressField(),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton(
                onPressed: ()=> showPaymentSuccessPopup(context),
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
                  "ትኬት ይረጋገጡ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckOutItem(CartItemModel item, int index) {
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
      ],
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ክፍያ መንገድ",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSansEthiopic',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildPaymentOption('cash', Icons.payments, "ገንዘብ"),
            const SizedBox(width: 16),
            _buildPaymentOption('bank', Icons.account_balance, "ባንክ"),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String value, IconData icon, String label) {
    final isSelected = selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: selectedPaymentMethod,
            onChanged: (val) {
              setState(() {
                selectedPaymentMethod = val!;
              });
            },
            activeColor: Colors.blue,
          ),
          Icon(icon, color: isSelected ? Colors.blue : Colors.black),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.blue : Colors.black,
              fontFamily: 'NotoSansEthiopic',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ስልክ ቁጥር",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSansEthiopic',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "ስልክ ቁጥር ያስገቡ",
            hintStyle: TextStyle(
              fontFamily: 'NotoSansEthiopic',
              color: Colors.grey.shade400,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "አድራሻ",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSansEthiopic',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: addressController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "አድራሻ ያስገቡ",
            hintStyle: TextStyle(
              fontFamily: 'NotoSansEthiopic',
              color: Colors.grey.shade400,
            ),
            prefixIcon: const Icon(Icons.location_on_outlined),
            suffixIcon: const Icon(Icons.my_location_outlined),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  void showPaymentSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: const PaymentSuccessPopupContent(),
        );
      },
    );
  }
}


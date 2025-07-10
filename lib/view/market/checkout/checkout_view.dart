import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/models/cart_model.dart';
import 'package:lenat_mobile/view/market/checkout/checkout_viewmodel.dart';
import 'package:lenat_mobile/view/market/checkout/widget/payment_success_popups.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CheckOutView extends StatefulWidget {
  const CheckOutView({super.key});

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load checkout data when the view initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CheckoutViewModel>(context, listen: false).loadCheckoutData();
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensure view resizes when keyboard appears
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
      ),
      body: SafeArea(
        child: Consumer<CheckoutViewModel>(
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
                      onPressed: () => viewModel.loadCheckoutData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (viewModel.cartItems.isEmpty) {
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
                      profileViewModel.isAmharic ? 'የግብይት ዕቃዎ ባዶ ነው' : 'Your cart is empty',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(     
                      profileViewModel.isAmharic ? 'ለመግዛት ወደ ገበያ ይመለሱ' : 'Please add items to your cart',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/market');
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
                      child: Text(
                        profileViewModel.isAmharic ? 'ወደ ገበያ ይሂዱ' : 'Proceed to Checkout',
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

            // Update controllers with viewModel data if available
            if (viewModel.phoneNumber.isNotEmpty &&
                phoneController.text.isEmpty) {
              phoneController.text = viewModel.phoneNumber;
            }
            if (viewModel.address.isNotEmpty &&
                addressController.text.isEmpty) {
              addressController.text = viewModel.address;
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          profileViewModel.isAmharic ? 'የትኬት ዝርዝር' : 'Order Summary',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'NotoSansEthiopic',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: viewModel.cartItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildCheckOutItem(
                              viewModel.cartItems[index],
                              profileViewModel,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Payment section moved from bottomNavigationBar to main body
                  Container(
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildPaymentMethodSelection(viewModel, profileViewModel),
                        const SizedBox(height: 16),
                        _buildPhoneField(viewModel, profileViewModel),
                        const SizedBox(height: 16),
                        _buildAddressField(viewModel, profileViewModel),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ElevatedButton(
                            onPressed: viewModel.isLoading
                                ? null
                                : () => _placeOrder(context, viewModel, profileViewModel),
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
                            child: viewModel.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    profileViewModel.isAmharic ? "ይዘዙ" : "Place Order",
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
                  // Add padding at the bottom to ensure everything is visible when keyboard is open
                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom + 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCheckOutItem(CartItemModel item, ProfileViewModel profileViewModel) {
    return Row(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    profileViewModel.isAmharic ? '${item.price} ብር' : '${item.price} Birr',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                  Text(
                    profileViewModel.isAmharic ? 'ብዛት: ${item.quantity}' : 'Quantity: ${item.quantity}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelection(CheckoutViewModel viewModel, ProfileViewModel profileViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profileViewModel.isAmharic ? "ክፍያ መንገድ" : "Payment Method",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSansEthiopic',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildPaymentOption('cash', Icons.payments, profileViewModel.isAmharic ? "ገንዘብ" : "Cash", viewModel),
            const SizedBox(width: 16),
            _buildPaymentOption(
                'bank', Icons.account_balance, profileViewModel.isAmharic ? "ባንክ" : "Bank", viewModel),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
      String value, IconData icon, String label, CheckoutViewModel viewModel) {
    final isSelected = viewModel.selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () {
        viewModel.setPaymentMethod(value);
      },
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: viewModel.selectedPaymentMethod,
            onChanged: (val) {
              if (val != null) {
                viewModel.setPaymentMethod(val);
              }
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

  Widget _buildPhoneField(CheckoutViewModel viewModel, ProfileViewModel profileViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profileViewModel.isAmharic ? "ስልክ ቁጥር" : "Phone Number",
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
          onChanged: (value) => viewModel.setPhoneNumber(value),
          decoration: InputDecoration(
            hintText: profileViewModel.isAmharic ? "ስልክ ቁጥር ያስገቡ" : "Please enter your phone number",
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

  Widget _buildAddressField(CheckoutViewModel viewModel, ProfileViewModel profileViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profileViewModel.isAmharic ? "አድራሻ" : "Address",
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
          onChanged: (value) => viewModel.setAddress(value),
          decoration: InputDecoration(
            hintText: profileViewModel.isAmharic ? "አድራሻ ያስገቡ" : "Please enter your address",
            hintStyle: TextStyle(
              fontFamily: 'NotoSansEthiopic',
              color: Colors.grey.shade400,
            ),
            prefixIcon: const Icon(Icons.location_on_outlined),
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

  Future<void> _placeOrder(
      BuildContext context, CheckoutViewModel viewModel, ProfileViewModel profileViewModel) async {
    // Validate phone number
    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(profileViewModel.isAmharic ? 'ስልክ ቁጥር ያስገቡ' : 'Please enter your phone number')),
      );
      return;
    }

    // Validate address
    if (addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(profileViewModel.isAmharic ? 'አድራሻ ያስገቡ' : 'Please enter your address')),
      );
      return;
    }

    // Set values in viewModel
    viewModel.setPhoneNumber(phoneController.text);
    viewModel.setAddress(addressController.text);

    // Place order
    final success = await viewModel.placeOrder();

    if (success) {
      // Show success popup
      showPaymentSuccessPopup(context, viewModel.orderId);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.error ?? 'Failed to place order')),
      );
    }
  }

  void showPaymentSuccessPopup(BuildContext context, String? orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: PaymentSuccessPopupContent(orderId: orderId),
        );
      },
    ).then((_) {
      // Navigate to home after closing the popup
      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
    });
  }
}

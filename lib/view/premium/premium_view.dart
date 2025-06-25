import 'package:chapasdk/chapasdk.dart';
import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/premium/premium_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumView extends StatefulWidget {
  const PremiumView({super.key});

  @override
  State<PremiumView> createState() => _PremiumViewState();
}

class _PremiumViewState extends State<PremiumView> {
  int selectedIndex = 1;

  final List<SubscriptionOption> options = [
    SubscriptionOption(
      title: '1 ወር አቅርቦት',
      price: '900',
      features: [
        'Lorem ipsum dolor sit amet',
        'Lorem ipsum dolor sit amet',
        'Lorem ipsum dolor sit amet',
      ],
    ),
    SubscriptionOption(
      title: '3 ወር አቅርቦት',
      price: '1,500',
      features: [
        'Lorem ipsum dolor sit amet',
        'Lorem ipsum dolor sit amet',
        'Lorem ipsum dolor sit amet',
      ],
      isRecommended: true,
    ),
    SubscriptionOption(
      title: '6 ወር አቅርቦት',
      price: '3,450',
      features: [
        'Lorem ipsum dolor sit amet',
        'Lorem ipsum dolor sit amet',
        'Lorem ipsum dolor sit amet',
      ],
    ),
  ];
  late final vm;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // vm = Provider.of<PremiumViewModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "ወደ ኋላ ይመለሱ",
          style: TextStyle(
            fontFamily: 'NotoSansEthiopic',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "ጥቅሎች",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSansEthiopic',
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: const Text(
                "Lorem ipsum dolor sit amet consectetur. Velit mauris etiam tortor adipiscing dis. Vulputate etiam sit dictum amet.",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? Primary : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Checkmark
                          if (isSelected)
                            const Icon(Icons.check_circle, color: Colors.white)
                          else
                            const SizedBox(width: 24),
                          const SizedBox(width: 12),
                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title and badge
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option.title,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (option.isRecommended)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'ተመረጠ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Features list
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: option.features.map((feature) {
                                    return Row(
                                      children: [
                                        const Text(
                                          '• ',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            feature,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Br',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                option.price,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Flexible(
              child: const Text(
                "Lorem ipsum dolor sit amet consectetur. Velit mauris etiam tortor adipiscing dis. Vulputate etiam sit dictum amet.Lorem ipsum dolor sit amet consectetur. Terms and Aggrement  tortor adipiscing dis. Privacy Policy sit dictum amet.Lorem ipsum dolor sit amet consectetur. Velit mauris etiam tortor",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () async {
                    // vm.proceedToPayment();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isPaid', true);
                    Chapa.paymentParameters(
                      context: context,
                      publicKey:
                          'CHAPUBK_TEST-j2vSkAytRDGAk3mXAVRhb9C6tyALG7Ep',
                      currency: 'ETB',
                      amount: options[selectedIndex].price,
                      email: 'fetanchapa.co',
                      phone: '0900123456',
                      firstName: 'Israel',
                      lastName: 'Goytom',
                      txRef: 'txn_${DateTime.now().millisecondsSinceEpoch}',
                      title: 'Order Payment',
                      desc: 'Payment for order #12345',
                      nativeCheckout: true,
                      namedRouteFallBack: '/main',
                      showPaymentMethodsOnGridView: true,
                      availablePaymentMethods: [
                        'mpesa',
                        'cbebirr',
                        'telebirr',
                        'ebirr',
                      ],
                      onPaymentFinished: (message, reference, amount) {
                        Navigator.pop(context);
                      },
                      buttonColor: Primary,
                    );
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
                    "ወደ ክፍያ ይቀጥሉ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionOption {
  final String title;
  final String price;
  final List<String> features;
  final bool isRecommended;

  SubscriptionOption({
    required this.title,
    required this.price,
    required this.features,
    this.isRecommended = false,
  });
}

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int selectedSizeIndex = 1;
  int selectedColorIndex = 0;
  bool isDescriptionExpanded = false;

  final List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];
  final List<String> colors = ['Pink', 'Blue', 'Green', 'Beige'];
  final List<String> images = [
    'assets/images/dress1.png',
    'assets/images/dress1.png',
    'assets/images/dress1.png',
    'assets/images/dress1.png',
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
              const Text(
                'የምርቱ ዝርዝር',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'NotoSansEthiopic',
                  fontWeight: FontWeight.w700,
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
                      child: Image.asset(
                        'assets/images/dress1.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
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
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  images[index],
                                  fit: BoxFit.cover,
                                  width: 80,
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
                  const Expanded(
                    child: Text(
                      "የምርቱ ስም",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFFCEACC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Color(0xFFFFB200),
                          size: 16,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          "4.9",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFFB200),
                          ),
                        ),
                      ],
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
                    "እንቅስቃሴ የሚያስተዳድር እና የተወዳጅ የማህፀን ልብስ የሚያቀርብ የምርት ስብስ ይዘው በሙሉ ወቅት ይወዳድሩ። የእኛ ኮሌክሽን ይዘው ይገኛሉ።... ",
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
                    child: const Text(
                      "Read More",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),

              // Size Selection
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ልብስ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 32,
                    children: List.generate(sizes.length, (index) {
                      final isSelected = selectedSizeIndex == index;
                      final isDisabled = sizes[index] == 'XXL';

                      return GestureDetector(
                        onTap: isDisabled
                            ? null
                            : () {
                                setState(() {
                                  selectedSizeIndex = index;
                                });
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isDisabled
                                ? Colors.grey.shade100
                                : isSelected
                                    ? Colors.blue
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDisabled
                                  ? Colors.grey.shade300
                                  : isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade400,
                            ),
                          ),
                          child: Text(
                            sizes[index],
                            style: TextStyle(
                              color: isDisabled
                                  ? Colors.grey
                                  : isSelected
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'NotoSansEthiopic',
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "ቀለም ይምረጡ (አማራጭ)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    children: List.generate(colors.length, (index) {
                      final isSelected = selectedColorIndex == index;
                      final isDisabled = colors[index] == 'Beige';

                      return GestureDetector(
                        onTap: isDisabled
                            ? null
                            : () {
                                setState(() {
                                  selectedColorIndex = index;
                                });
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isDisabled
                                ? Colors.grey.shade100
                                : isSelected
                                    ? Colors.blue
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDisabled
                                  ? Colors.grey.shade300
                                  : isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade400,
                            ),
                          ),
                          child: Text(
                            colors[index],
                            style: TextStyle(
                              color: isDisabled
                                  ? Colors.grey
                                  : isSelected
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'NotoSansEthiopic',
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
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
                  "Total Price",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
                Text(
                  "2, 500 ብር",
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
              child: const Center(
                child: Text(
                  "አሁን ይግዙ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
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
              child: const Center(
                child: Icon(
                  Icons.shopping_bag,
                  color: Primary,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

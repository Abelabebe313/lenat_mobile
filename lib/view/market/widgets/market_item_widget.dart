import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class MarketItemWidget extends StatelessWidget {
  const MarketItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/dress1.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Positioned(
                bottom: 10,
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
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "የነፍሰ ጡር ልብስ",
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
        ],
      ),
    );
  }
}

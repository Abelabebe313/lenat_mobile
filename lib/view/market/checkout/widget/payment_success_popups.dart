import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';

class PaymentSuccessPopupContent extends StatelessWidget {
  final String? orderId;

  const PaymentSuccessPopupContent({
    super.key,
    this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedCheckmarkCircle02,
            color: Primary,
            size: 80,
          ),
          const SizedBox(height: 20),
          const Text(
            "ትእዛዝ ተረጋግጧል",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSansEthiopic',
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (orderId != null && orderId != 'unknown') ...[
                Text(
                  "ትእዛዝ ቁጥር: #$orderId",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              const Text(
                "በቅርቡ ከለእናት የደንበኛ ድጋፍ ሰጪ አባላችን የሰልክ ጥራ ይደርሶታል።",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
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
              child: const Text(
                "ወደ መነሻ ይመለሱ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:pinput/pinput.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({super.key});

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: 'NotoSansEthiopic',
    ),
    decoration: BoxDecoration(
      color: Color(0xFFF2F2F2),
      borderRadius: BorderRadius.circular(12),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'ውጣ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'NotoSansEthiopic',
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isTablet = screenWidth >= 600;

          final horizontalPadding = isTablet ? 40.0 : 20.0;
          final titleFontSize = isTablet ? 32.0 : 26.0;
          final inputFontSize = isTablet ? 16.0 : 14.0;
          final buttonPadding = isTablet ? 16.0 : 12.0;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    "እባክዎ የማረጋገጫ \nኮድ ያስገቡ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Pinput(
                  length: 5,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue),
                    ),
                  ),
                  onCompleted: (value) {
                    print('Entered code: $value');
                    // TODO: Add your verification logic here
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "00:45",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: inputFontSize,
                        fontWeight: FontWeight.w700,
                        color: Primary,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "እቅፍ ይደርሳል ይህ የማይታወቅ ጽሁፍ ነው። ይህ የሚያስተዋውቅ ይህ የማይታወቅ ጽሁፍ ነው።",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: inputFontSize,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ኮድ አልደረሰዎትም?",
                      style: TextStyle(
                        fontSize: inputFontSize,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "ይድገሙ",
                        style: TextStyle(
                          fontSize: inputFontSize,
                          fontWeight: FontWeight.w700,
                          color: Primary,
                          fontFamily: 'NotoSansEthiopic',
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, "/gender-selection");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 80 : 60,
                      vertical: buttonPadding,
                    ),
                  ),
                  child: Text(
                    "ይቀጥሉ",
                    style: TextStyle(
                      fontSize: inputFontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

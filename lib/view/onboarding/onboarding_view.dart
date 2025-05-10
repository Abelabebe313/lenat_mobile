import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: height * 0.05), // Responsive top spacing
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.06),
            height: height * 0.4,
            child: Stack(
              children: [
                Positioned(
                  top: height * 0.01,
                  left: width * 0.1,
                  child: Image.asset(
                    'assets/images/image.png',
                    fit: BoxFit.cover,
                    width: width * 0.3,
                    height: width * 0.3,
                  ),
                ),
                Positioned(
                  top: height * 0.02,
                  right: width * 0.1,
                  child: Image.asset(
                    'assets/images/image2.png',
                    fit: BoxFit.cover,
                    width: width * 0.3,
                    height: width * 0.3,
                  ),
                ),
                Positioned(
                  bottom: height * 0.05,
                  left: 0,
                  child: Image.asset(
                    'assets/images/image3.png',
                    fit: BoxFit.cover,
                    width: width * 0.35,
                    height: width * 0.35,
                  ),
                ),
                Positioned(
                  bottom: height * 0.02,
                  right: width * 0.02,
                  child: Image.asset(
                    'assets/images/image4.png',
                    fit: BoxFit.cover,
                    width: width * 0.35,
                    height: width * 0.35,
                  ),
                ),
                Center(
                  child: CircleAvatar(
                    radius: width * 0.18,
                    backgroundColor: Primary,
                    child: Image.asset(
                      'assets/icons/logo.png',
                      fit: BoxFit.contain,
                      width: width * 0.15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.02),
          Text(
            "እንኳን በደህና መጡ",
            style: TextStyle(
              fontSize: width * 0.065,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontFamily: 'NotoSansEthiopic',
            ),
          ),
          Text(
            "የጤና እና የእርግዝና መረጃዎችን ለማግኘት\n የተሟሉ ተሞክሮ ይቀበሉ።",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontFamily: 'NotoSansEthiopic',
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/login");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.2,
                vertical: height * 0.015,
              ),
            ),
            child: Text(
              "ጉዞዎን ይጀምሩ",
              style: TextStyle(
                fontSize: width * 0.045,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'NotoSansEthiopic',
              ),
            ),
          ),
          SizedBox(height: height * 0.05),
        ],
      ),
    );
  }
}

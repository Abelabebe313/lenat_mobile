import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final isTablet = screenWidth >= 600;

            final horizontalPadding = isTablet ? 40.0 : 20.0;
            final titleFontSize = isTablet ? 32.0 : 26.0;
            final inputFontSize = isTablet ? 16.0 : 14.0;
            final buttonPadding = isTablet ? 16.0 : 12.0;

            final titleStyle = TextStyle(
              fontSize: inputFontSize,
              fontWeight: FontWeight.w700,
              fontFamily: 'NotoSansEthiopic',
            );

            final hintStyle = TextStyle(
              fontSize: inputFontSize,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.5),
              fontFamily: 'NotoSansEthiopic',
            );

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 250,
                          ),
                          child: Image.asset(
                            'assets/images/login-image.png',
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "ግባ",
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Form fields
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ኢሜይል / ስልክ ቁጥር", style: titleStyle),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: TextFieldColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "lenat@gmail.com",
                              hintStyle: hintStyle,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text("የይለፍ ቃል", style: titleStyle),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: TextFieldColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "********",
                              hintStyle: hintStyle,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "የይለፍ ቃልዎን ረስተዋል?",
                            style: titleStyle.copyWith(color: Primary),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/verification");
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
                        "ወደ ውስጥ ግባ",
                        style: TextStyle(
                          fontSize: inputFontSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'NotoSansEthiopic',
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "መለያ የለዎትም?",
                          style: TextStyle(
                            fontSize: inputFontSize,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NotoSansEthiopic',
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "ይመዝገቡ",
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
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/auth/auth_viewmodel.dart';
import 'package:lenat_mobile/view/auth/verfication_view.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'እባክዎ ኢሜይል ያስገቡ';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');
    final phoneRegex = RegExp(r'^(09|07)\d{8}');
    if (emailRegex.hasMatch(value)) {
      return null;
    } else if (phoneRegex.hasMatch(value)) {
      // Valid phone
      return null;
    } else {
      return 'እባክዎ ትክክለኛ ኢሜይል ወይም ስልክ ቁጥር ያስገቡ';
    }
  }

  String _normalizePhoneOrEmail(String value) {
    value = value.trim();
    final phoneRegex = RegExp(r'^(09|07)\d{8}');
    if (phoneRegex.hasMatch(value)) {
      // Remove leading 0 and add +251
      return '+251' + value.substring(1);
    }
    // If already in +251 format or email, return as is
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              profileViewModel.toggleLanguage();
            },
            child: Text(profileViewModel.isAmharic ? "አማርኛ" : "English"),
          ),
        ],
      ),
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
                      profileViewModel.isAmharic ? "ግባ" : "Login",
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Form fields
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profileViewModel.isAmharic ? "ኢሜይል" : "Email",
                            style: titleStyle,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: TextFieldColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "email@example.com or 09... or  07..",
                                hintStyle: hintStyle,
                                border: InputBorder.none,
                              ),
                              validator: _validateEmailOrPhone,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _loading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => _loading = true);
                                try {
                                  String input = _emailController.text.trim();
                                  final normalized =
                                      _normalizePhoneOrEmail(input);
                                  await viewModel.getAuthOtp(normalized);
                                  if (context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const VerificationView(),
                                        settings: RouteSettings(
                                            arguments: normalized),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    String errorMessage = 'Failed to send OTP';
                                    if (e.toString().contains(
                                        'Malformed Authorization Header')) {
                                      errorMessage =
                                          'Authentication error. Please try again.';
                                    } else if (e
                                        .toString()
                                        .contains('Network')) {
                                      errorMessage =
                                          'Network error. Please check your connection.';
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(errorMessage),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } finally {
                                  setState(() => _loading = false);
                                }
                              }
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
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              profileViewModel.isAmharic
                                  ? "ወደ ውስጥ ግባ"
                                  : "Login",
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
                          profileViewModel.isAmharic
                              ? "መለያ የለዎትም?"
                              : "Don't have an account?",
                          style: TextStyle(
                            fontSize: inputFontSize,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NotoSansEthiopic',
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            profileViewModel.isAmharic ? "ይመዝገቡ" : "Sign up",
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
                    // i want to show a google svg to login with google
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   spacing: 16,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () async {
                    //         final googleUrl = await viewModel.getGoogleUrl();
                    //         if (googleUrl != null) {
                    //           String? authCode;
                    //           await showDialog(
                    //             context: context,
                    //             barrierDismissible: false,
                    //             builder: (context) {
                    //               return Dialog(
                    //                 insetPadding: const EdgeInsets.all(16),
                    //                 child: SizedBox(
                    //                   height: 600,
                    //                   child: InAppWebView(
                    //                     initialUrlRequest: URLRequest(
                    //                         url: WebUri(Uri.parse(googleUrl)
                    //                             .toString())),
                    //                     initialOptions:
                    //                         InAppWebViewGroupOptions(
                    //                       crossPlatform: InAppWebViewOptions(
                    //                         javaScriptEnabled: true,
                    //                       ),
                    //                     ),
                    //                     onLoadStart: (controller, url) async {
                    //                       if (url != null &&
                    //                           url
                    //                               .toString()
                    //                               .contains("code=") &&
                    //                           url.toString().contains(
                    //                               "/auth/google/callback")) {
                    //                         final uri =
                    //                             Uri.parse(url.toString());
                    //                         authCode =
                    //                             uri.queryParameters["code"];

                    //                         if (authCode != null) {
                    //                           Navigator.of(context)
                    //                               .pop(); // Close dialog
                    //                         }
                    //                       }
                    //                     },
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //           );

                    //           if (authCode != null) {
                    //             final isNewUser = await viewModel
                    //                 .handleGoogleSignIn(authCode!);
                    //             if (isNewUser) {
                    //               // Navigate to profile completion screen
                    //             } else {
                    //               // Navigate to home screen
                    //             }
                    //           } else {
                    //             ScaffoldMessenger.of(context).showSnackBar(
                    //               const SnackBar(
                    //                   content: Text(
                    //                       "Failed to retrieve authorization code")),
                    //             );
                    //           }
                    //         } else {
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //             const SnackBar(
                    //                 content:
                    //                     Text("Could not launch sign-in URL")),
                    //           );
                    //         }
                    //       },
                    //       child: SizedBox(
                    //         child: SvgPicture.asset(
                    //           'assets/svg/google.svg',
                    //           width: 32,
                    //           height: 32,
                    //         ),
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () async {
                    //         final phone = "+251917914528";
                    //         try {
                    //           await viewModel.startTelegramLogin(phone);

                    //           final isNewUser =
                    //               await viewModel.completeTelegramLogin();
                    //           if (context.mounted) {
                    //             if (isNewUser) {
                    //               Navigator.pushReplacementNamed(
                    //                   context, '/gender-selection');
                    //             } else {
                    //               Navigator.pushReplacementNamed(
                    //                   context, '/main');
                    //             }
                    //           }
                    //         } catch (e) {
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //             SnackBar(
                    //                 content: Text("Telegram login failed: $e")),
                    //           );
                    //         }
                    //       },
                    //       child: SizedBox(
                    //         child: SvgPicture.asset(
                    //           'assets/svg/telegram.svg',
                    //           width: 40,
                    //           height: 40,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
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

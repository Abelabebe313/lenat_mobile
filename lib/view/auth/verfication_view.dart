import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/auth/auth_viewmodel.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({super.key});

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  Timer? _timer;
  int _remainingSeconds = 120; // 2 minutes in seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  String _formatTime() {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

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
    final email = ModalRoute.of(context)?.settings.arguments as String?;
    final viewModel = Provider.of<AuthViewModel>(context);
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    print('Verification view - Email received: $email'); // Debug print

    // If email is null, try to get it from SharedPreferences
    if (email == null) {
      SharedPreferences.getInstance().then((prefs) {
        final savedEmail = prefs.getString('last_email');
        print('Retrieved email from SharedPreferences: $savedEmail');
        if (savedEmail != null && context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const VerificationView(),
              settings: RouteSettings(arguments: savedEmail),
            ),
          );
        }
      });
    }

    if (email == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Error: Missing email",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Go Back"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          profileViewModel.isAmharic ? 'ውጣ' : 'Back',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'NotoSansEthiopic',
          ),
        ),
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
        child: LayoutBuilder(builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isTablet = screenWidth >= 600;

          final horizontalPadding = isTablet ? 40.0 : 16.0;
          final titleFontSize = isTablet ? 32.0 : 20.0;
          final inputFontSize = isTablet ? 16.0 : 14.0;
          final buttonPadding = isTablet ? 16.0 : 12.0;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      profileViewModel.isAmharic
                          ? "እባክዎ የማረጋገጫ \nኮድ ያስገቡ"
                          : "Please enter the code sent to\n$email",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profileViewModel.isAmharic
                        ? "የማረጋገጫ ኮድ ወደ:\n$email ተሰጥቷል"
                        : "OTP has been sent to:\n$email",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: inputFontSize,
                      color: Colors.grey[600],
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                  const SizedBox(height: 30),
                  Pinput(
                    length: 6,
                    key: _formKey,
                    controller: _otpController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue),
                      ),
                    ),
                    onCompleted: (value) async {
                      print('OTP entered: $value');
                      setState(() => _loading = true);
                      try {
                        print('Verifying OTP for email: $email');
                        final user =
                            await viewModel.handleOtpCallback(email, value);
                        print(
                            'Verification result - isNewUser: ${user?.isNewUser}');
                        if (context.mounted && user != null) {
                          if (user.isNewUser) {
                            // New user - go to gender selection to start profile setup
                            Navigator.pushReplacementNamed(
                                context, '/gender-selection');
                          } else {
                            // Existing user - go directly to main
                            Navigator.pushReplacementNamed(context, '/main');
                          }
                        }
                      } catch (e) {
                        print('Verification error: $e');
                        if (context.mounted) {
                          String errorMessage = 'Verification failed';
                          if (e.toString().contains('Invalid OTP')) {
                            errorMessage =
                                'Invalid verification code. Please try again.';
                          } else if (e.toString().contains('Network')) {
                            errorMessage =
                                'Network error. Please check your connection.';
                          } else if (e
                              .toString()
                              .contains('Malformed Authorization Header')) {
                            errorMessage =
                                'Authentication error. Please try again.';
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
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _formatTime(),
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
                        profileViewModel.isAmharic
                            ? "ኮድ አልደረሰዎትም?"
                            : "Didn't get Code?",
                        style: TextStyle(
                          fontSize: inputFontSize,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'NotoSansEthiopic',
                        ),
                      ),
                      TextButton(
                        onPressed: _remainingSeconds == 0
                            ? () async {
                                setState(() => _loading = true);
                                try {
                                  await viewModel.getAuthOtp(email);
                                  setState(() {
                                    _remainingSeconds = 120;
                                    _startTimer();
                                  });
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Failed to resend OTP: $e")),
                                    );
                                  }
                                } finally {
                                  setState(() => _loading = false);
                                }
                              }
                            : null,
                        child: Text(
                          profileViewModel.isAmharic
                              ? "ይድገሙ"
                              : "Resend Code",
                          style: TextStyle(
                            fontSize: inputFontSize,
                            fontWeight: FontWeight.w700,
                            color:
                                _remainingSeconds == 0 ? Primary : Colors.grey,
                            fontFamily: 'NotoSansEthiopic',
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

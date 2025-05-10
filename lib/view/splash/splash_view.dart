import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/splash/splash_viewmodel.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () async {
      final vm = Provider.of<SplashViewModel>(context, listen: false);
      final nextRoute = await vm.decideNextRoute();
      if (mounted) {
        Navigator.pushReplacementNamed(context, nextRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Primary,
      body: Center(
        child: Image.asset(
          'assets/icons/logo.png',
          fit: BoxFit.cover,
          width: 100,
        ),
      ),
    );
  }
}

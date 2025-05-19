import 'package:flutter/material.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:lenat_mobile/services/local_storage.dart';

import '../../app/service_locator.dart';

class SplashViewModel extends ChangeNotifier {
  final AuthService _authService = locator<AuthService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  Future<String> decideNextRoute() async {
    final isFirstLaunch = await _localStorageService.isFirstLaunch();
    if (isFirstLaunch) return '/onboarding';

    final isLoggedIn = await _authService.isLoggedIn();
    if (!isLoggedIn) return '/login';

    final isProfileComplete = await _authService.isProfileComplete();
    if (!isProfileComplete) return '/profile-setup';

    return '/main';
  }
}

import 'package:flutter/material.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:lenat_mobile/services/local_storage.dart';
import 'package:lenat_mobile/models/user_model.dart';
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

    // Get current user to check if they are new
    final user = await _authService.getCurrentUser();
    if (user == null) return '/login';

    // If user is new (new_user: true), they need to complete profile setup
    if (user.isNewUser) {
      return '/gender-selection';
    }

    // Existing user (new_user: false) goes directly to main
    return '/main';
  }
}

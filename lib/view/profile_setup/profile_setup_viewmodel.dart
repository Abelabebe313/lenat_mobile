import 'package:flutter/material.dart';
import 'package:lenat_mobile/app/service_locator.dart';
import 'package:lenat_mobile/services/auth_service.dart';

class ProfileSetupViewModel extends ChangeNotifier {
  final _authService = locator<AuthService>();
  String _selectedGender = "female";
  bool _isLoading = false;

  String get selectedIndex => _selectedGender;
  bool get isLoading => _isLoading;

  void updateIndex(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String fullName,
    required String dateOfBirth,
    String? relationship,
    int? pregnancyPeriod,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.updateUserProfile(
        gender: _selectedGender,
        fullName: fullName,
        dateOfBirth: dateOfBirth,
        relationship: relationship,
        pregnancyPeriod: pregnancyPeriod,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}

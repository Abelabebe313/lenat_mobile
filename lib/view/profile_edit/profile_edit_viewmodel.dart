import 'package:flutter/material.dart';
import 'package:lenat_mobile/app/service_locator.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:lenat_mobile/models/user_model.dart';

class ProfileEditViewModel extends ChangeNotifier {
  final _authService = locator<AuthService>();
  String _selectedGender = "female"; // Default value
  bool _isLoading = false;
  UserModel? _currentUser;

  String get selectedGender => _selectedGender;
  bool get isLoading => _isLoading;
  UserModel? get currentUser => _currentUser;

  Future<void> loadUserData() async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentUser = await _authService.getCurrentUser();
      if (_currentUser != null && _currentUser!.gender != null) {
        _selectedGender = _currentUser!.gender!;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading user data: $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String phoneNumber,
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
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        relationship: relationship,
        pregnancyPeriod: pregnancyPeriod,
      );

      // Reload user data after update
      await loadUserData();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Check if refresh token is expired
      if (e.toString().contains('Token has expired')) {
        // Logout and navigate to login
        await _authService.logout();
        throw Exception('REFRESH_TOKEN_EXPIRED');
      }

      print('Error updating profile: $e');
      rethrow;
    }
  }

  // Method to refresh profile data from main profile viewmodel
  Future<void> refreshProfileData() async {
    await loadUserData();
  }

  // Method to reset profile edit data when user logs out
  void resetProfileEditData() {
    _currentUser = null;
    _selectedGender = "female";
    _isLoading = false;
    notifyListeners();
  }
}

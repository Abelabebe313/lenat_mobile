import 'package:flutter/material.dart';
import 'package:lenat_mobile/app/service_locator.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:lenat_mobile/models/user_model.dart';
import 'package:lenat_mobile/services/graphql_service.dart';

class ProfileEditViewModel extends ChangeNotifier {
  final _authService = locator<AuthService>();
  String _selectedGender = "female"; // Default value
  bool _isLoading = false;
  UserModel? _currentUser;

  // Callback function to refresh profile data
  Function? _onProfileUpdated;

  String get selectedGender => _selectedGender;
  bool get isLoading => _isLoading;
  UserModel? get currentUser => _currentUser;

  // Method to set selected gender
  void setSelectedGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  // Set callback for profile refresh
  void setProfileUpdateCallback(Function callback) {
    _onProfileUpdated = callback;
  }

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

      // Fetch fresh data from server after successful update
      await _refreshUserDataFromServer();

      // Call the callback to refresh profile screen data
      if (_onProfileUpdated != null) {
        _onProfileUpdated!();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      // Check for various token/auth error messages
      final errorMsg = e.toString().toLowerCase();
      final isAuthError = errorMsg.contains('token') ||
          errorMsg.contains('jwt') ||
          errorMsg.contains('auth') ||
          errorMsg.contains('unauthorized') ||
          errorMsg.contains('expired');

      if (isAuthError) {
        print('Authentication error detected: $e');
        // Attempt to refresh tokens
        final refreshed = await GraphQLService.refreshTokens();
        if (!refreshed) {
          // If refresh failed, logout and redirect to login
          print('Token refresh failed, logging out user');
          await _authService.logout();
          throw Exception('SESSION_EXPIRED');
        } else {
          // If refresh succeeded, throw a different error to indicate retry
          print('Token refreshed successfully, user should retry operation');
          throw Exception('RETRY_OPERATION');
        }
      }

      print('Error updating profile: $e');
      rethrow;
    }
  }

  // Fetch fresh user data from server
  Future<void> _refreshUserDataFromServer() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser != null) {
        // Fetch fresh data from server
        final freshUserData =
            await _authService.fetchCompleteUserData(currentUser.id!);
        if (freshUserData != null) {
          _currentUser = freshUserData;
          if (_currentUser!.gender != null) {
            _selectedGender = _currentUser!.gender!;
          }
          print('✅ ProfileEditViewModel: User data refreshed from server');
        }
      }
    } catch (e) {
      print('Error refreshing user data from server: $e');
      // Don't throw here, just log the error
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

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lenat_mobile/app/service_locator.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:lenat_mobile/models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final _authService = locator<AuthService>();
  final _storage = FlutterSecureStorage();

  String? _ssid;
  String? _tsession;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<String?> getAuthOtp(String email) async {
    final result = await _authService.getAuthOtp(email);
    if (result == null) {
      throw Exception('Failed to get OTP');
    }
    print('OTP sent to $email: $result');
    return result;
  }

  Future<UserModel?> handleOtpCallback(String email, String otp) async {
    final user = await _authService.handleOtpCallback(email, otp);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
    }
    return user;
  }

  Future<void> updateUserProfile({
    required String gender,
    String? profileImage,
    String? fullName,
    String? dateOfBirth,
    String? bio,
  }) async {
    await _authService.updateUserProfile(
      gender: gender,
      profileImage: profileImage,
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      bio: bio,
    );
    _currentUser = await _authService.getCurrentUser();
    notifyListeners();
  }

  Future<bool> isProfileComplete() async {
    return _authService.isProfileComplete();
  }

  Future<String?> getGoogleUrl() async {
    final result = await _authService.getGoogleAuthUrl();
    if (result == null) {
      throw Exception('Failed to get Google Auth URL');
    }
    print('Google Auth URL: $result');
    return result;
  }

  Future<bool> handleGoogleSignIn(String code) async {
    final result = await _authService.handleGoogleCallback(code);

    if (result != null) {
      if (result['complete_user'] != null) {
        _currentUser = UserModel.fromJson(result['complete_user']);
        notifyListeners();
      }
      return result['new_user'] ?? false;
    }

    return false;
  }

  Future<void> startTelegramLogin(String phone) async {
    final result = await _authService.startTelegramAuth(phone);
    if (result != null) {
      _ssid = result['ssid'];
      _tsession = result['tsession'];
    } else {
      throw Exception('Telegram login initiation failed.');
    }
  }

  Future<bool> completeTelegramLogin() async {
    if (_ssid == null || _tsession == null) {
      throw Exception("Missing session data");
    }

    final result = await _authService.completeTelegramAuth(_ssid!, _tsession!);
    if (result != null) {
      if (result['complete_user'] != null) {
        _currentUser = UserModel.fromJson(result['complete_user']);
        notifyListeners();
      }
      return result['new_user'] ?? false;
    }

    return false;
  }

  Future<void> logout() async {
    try {
      // Clear all user data from memory
      _currentUser = null;
      _ssid = null;
      _tsession = null;

      // Clear secure storage and preferences
      await _authService.logout();

      // Notify listeners to update UI
      notifyListeners();

      print('AuthViewModel logout completed');
    } catch (e) {
      print('Error in AuthViewModel logout: $e');
      // Even if there's an error, clear the in-memory data
      _currentUser = null;
      _ssid = null;
      _tsession = null;
      notifyListeners();
    }
  }
}

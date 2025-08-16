import 'package:flutter/material.dart';
import 'package:lenat_mobile/app/service_locator.dart';
import 'package:lenat_mobile/models/user_model.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:lenat_mobile/services/minio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

class ProfileViewModel extends ChangeNotifier {
  final _authService = locator<AuthService>();
  final _minioService = locator<MinioService>();
  static const String _languageKey = 'app_language';
  bool _isAmharic = true;
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isUploading = false;
  String? _uploadedImageUrl;

  bool get isAmharic => _isAmharic;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get uploadedImageUrl => _uploadedImageUrl;

  ProfileViewModel() {
    _loadLanguagePreference();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isAmharic = prefs.getBool(_languageKey) ?? true;
    notifyListeners();
  }

  Future<void> loadUserData() async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentUser = await _authService.getCurrentUser();
      print("current user: ${_currentUser?.email}");

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Refresh user data from server (for pull-to-refresh and after profile updates)
  Future<void> refreshUserData() async {
    try {
      _isLoading = true;
      notifyListeners();

      final currentUser = await _authService.getCurrentUser();
      if (currentUser != null) {
        // Fetch fresh data from server
        final freshUserData =
            await _authService.fetchCompleteUserData(currentUser.id!);
        if (freshUserData != null) {
          _currentUser = freshUserData;
          print('✅ ProfileViewModel: Profile data refreshed from server');
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error refreshing user data: $e');
      rethrow;
    }
  }

  Future<void> uploadProfileImage(File imageFile) async {
    try {
      _isUploading = true;
      notifyListeners();

      // 1. Extract the file name from the path
      final fileName = imageFile.path.split('/').last;
      print("fileName: $fileName");
      // final fileName = path.basename(imageFile.path);
      final profileUploadUrl =
          await _authService.getProfileUploadUrl(fileName);
      
      if (profileUploadUrl == null) throw Exception("Failed to get upload URL");

      // 2. Upload to MinIO using pre-signed URL
      final bytes = await imageFile.readAsBytes();
      final response = await http.put(
        Uri.parse(profileUploadUrl['url']),
        body: bytes,
        headers: {"Content-Type": "image/jpeg"},
      );

       // 3. Refresh user data so new image shows up
      await refreshUserData();

      _isUploading = false;
      notifyListeners();
    } catch (e) {
      _isUploading = false;
      notifyListeners();
      print('Error uploading profile image: $e');
      rethrow;
    }
  }

  Future<void> toggleLanguage() async {
    _isAmharic = !_isAmharic;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_languageKey, _isAmharic);
    notifyListeners();
  }

  String getLanguageText() {
    return _isAmharic ? 'አማርኛ' : 'English';
  }

  String getLanguageToggleText() {
    return _isAmharic ? 'Switch to English' : 'አማርኛ ቋንቋ ላይ ቀይር';
  }

  // Method to reset profile data when user logs out
  void resetProfileData() {
    _currentUser = null;
    _uploadedImageUrl = null;
    _isLoading = false;
    _isUploading = false;
    _isAmharic = true; // Reset to default language
    notifyListeners();
  }

  // Danger zone 
  Future<void> deleteAccount(String userId) async {
    await _authService.deleteAccount(userId);
  }
}

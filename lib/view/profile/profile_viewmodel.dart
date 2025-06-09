import 'package:flutter/material.dart';
import 'package:lenat_mobile/app/service_locator.dart';
import 'package:lenat_mobile/models/user_model.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends ChangeNotifier {
  final _authService = locator<AuthService>();
  static const String _languageKey = 'app_language';
  bool _isAmharic = true;
  UserModel? _currentUser;
  bool _isLoading = false;

  bool get isAmharic => _isAmharic;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  ProfileViewModel() {
    _loadLanguagePreference();
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

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
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
}

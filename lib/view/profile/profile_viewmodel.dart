import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  bool _isAmharic = true;

  bool get isAmharic => _isAmharic;

  ProfileViewModel() {
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isAmharic = prefs.getBool(_languageKey) ?? true;
    notifyListeners();
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

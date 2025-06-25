import 'package:flutter/material.dart';
import 'package:lenat_mobile/services/trivia_service.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:lenat_mobile/models/trivia_model.dart';
import 'package:lenat_mobile/app/service_locator.dart';

class TriviaViewModel extends ChangeNotifier {
  final _authService = locator<AuthService>();
  List<TriviaModel> _triviaList = [];
  bool _isLoading = false;
  String? _error;

  List<TriviaModel> get triviaList => _triviaList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTrivia(BuildContext context) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _triviaList = await TriviaService.getAllTrivia();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;

      // Check if refresh token is expired
      if (e.toString().contains('Token has expired')) {
        // Logout and navigate to login
        await _authService.logout();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
        return;
      }

      _error = e.toString();
      notifyListeners();
      print('Error loading trivia: $e');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

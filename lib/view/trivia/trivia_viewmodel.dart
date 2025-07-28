import 'package:flutter/material.dart';
import 'package:lenat_mobile/services/trivia_service.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:lenat_mobile/services/trivia_progress_service.dart';
import 'package:lenat_mobile/models/trivia_model.dart';
import 'package:lenat_mobile/app/service_locator.dart';

class TriviaViewModel extends ChangeNotifier {
  final _authService = locator<AuthService>();
  final _triviaProgressService = locator<TriviaProgressService>();
  
  List<TriviaModel> _triviaList = [];
  Map<String, bool> _triviaUnlockStatus = {};
  Map<String, TriviaProgress> _triviaProgress = {};
  bool _isLoading = false;
  String? _error;

  List<TriviaModel> get triviaList => _triviaList;
  Map<String, bool> get triviaUnlockStatus => _triviaUnlockStatus;
  Map<String, TriviaProgress> get triviaProgress => _triviaProgress;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTrivia(BuildContext context) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _triviaList = await TriviaService.getAllTrivia();
      
      // Get all trivia IDs in order
      final List<String> triviaIds = _triviaList
          .map((trivia) => trivia.id ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
      
      // Load progress for all trivias
      _triviaProgress = await _triviaProgressService.getAllProgress();
      
      // Determine which trivias are unlocked
      _triviaUnlockStatus = {};
      for (final trivia in _triviaList) {
        if (trivia.id != null && trivia.id!.isNotEmpty) {
          _triviaUnlockStatus[trivia.id!] = 
              await _triviaProgressService.isTriviaUnlocked(trivia.id!, triviaIds);
        }
      }

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
    }
  }

  bool isTriviaUnlocked(String triviaId) {
    // First trivia is always unlocked
    if (_triviaList.isNotEmpty && _triviaList.first.id == triviaId) {
      return true;
    }
    
    return _triviaUnlockStatus[triviaId] ?? false;
  }
  
  TriviaProgress? getTriviaProgress(String triviaId) {
    return _triviaProgress[triviaId];
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:lenat_mobile/services/trivia_service.dart';
import 'package:lenat_mobile/services/auth_service.dart';
import 'package:lenat_mobile/models/question_model.dart';
import 'package:lenat_mobile/app/service_locator.dart';

class QuestionViewModel extends ChangeNotifier {
  final _authService = locator<AuthService>();
  List<QuestionModel> _questions = [];
  bool _isLoading = false;
  String? _error;
  int _currentQuestionIndex = 0;
  int _lives = 3;
  int _score = 0;
  bool _gameCompleted = false;
  bool _isWinner = false;

  List<QuestionModel> get questions => _questions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get lives => _lives;
  int get score => _score;
  bool get gameCompleted => _gameCompleted;
  bool get isWinner => _isWinner;
  QuestionModel? get currentQuestion =>
      _questions.isNotEmpty && _currentQuestionIndex < _questions.length
          ? _questions[_currentQuestionIndex]
          : null;

  Future<void> loadQuestions(String triviaId, BuildContext context) async {
    try {
      if (triviaId.isEmpty) {
        throw Exception('Invalid trivia ID provided');
      }

      _isLoading = true;
      _error = null;
      _currentQuestionIndex = 0;
      _lives = 3;
      _score = 0;
      _gameCompleted = false;
      _isWinner = false;
      notifyListeners();

      _questions = await TriviaService.getTriviaQuestions(triviaId);

      if (_questions.isEmpty) {
        _error = 'No questions found for this trivia';
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
      print('Error loading questions: $e');
    }
  }

  void answerQuestion(String selectedAnswer) {
    if (_gameCompleted || _currentQuestionIndex >= _questions.length) return;

    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect = selectedAnswer == currentQuestion.answer;

    if (isCorrect) {
      _score++;
    } else {
      _lives--;
    }

    // Move to next question or end game
    if (_currentQuestionIndex < _questions.length - 1 && _lives > 0) {
      _currentQuestionIndex++;
    } else {
      _gameCompleted = true;
      _isWinner = _lives > 0;
    }

    notifyListeners();
  }

  void resetGame() {
    _currentQuestionIndex = 0;
    _lives = 3;
    _score = 0;
    _gameCompleted = false;
    _isWinner = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;
  bool get isGameOver => _lives <= 0 || _gameCompleted;
}

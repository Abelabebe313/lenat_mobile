import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TriviaProgressService {
  static const String _triviaProgressKey = 'trivia_progress';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Get progress for all trivias
  Future<Map<String, TriviaProgress>> getAllProgress() async {
    try {
      final String? progressData =
          await _secureStorage.read(key: _triviaProgressKey);
      if (progressData == null || progressData.isEmpty) {
        return {};
      }

      final Map<String, dynamic> decodedData = jsonDecode(progressData);
      Map<String, TriviaProgress> result = {};

      decodedData.forEach((triviaId, progressData) {
        result[triviaId] = TriviaProgress.fromJson(progressData);
      });

      return result;
    } catch (e) {
      print('Error getting trivia progress: $e');
      return {};
    }
  }

  // Get progress for a specific trivia
  Future<TriviaProgress?> getTriviaProgress(String triviaId) async {
    try {
      final allProgress = await getAllProgress();
      return allProgress[triviaId];
    } catch (e) {
      print('Error getting specific trivia progress: $e');
      return null;
    }
  }

  // Save progress for a specific trivia
  Future<void> saveTriviaProgress(
      String triviaId, TriviaProgress progress) async {
    try {
      final allProgress = await getAllProgress();
      allProgress[triviaId] = progress;

      final Map<String, dynamic> dataToSave = {};
      allProgress.forEach((id, progress) {
        dataToSave[id] = progress.toJson();
      });

      final String encodedData = jsonEncode(dataToSave);
      await _secureStorage.write(key: _triviaProgressKey, value: encodedData);
    } catch (e) {
      print('Error saving trivia progress: $e');
    }
  }

  // Check if a trivia is unlocked
  Future<bool> isTriviaUnlocked(
      String triviaId, List<String> allTriviaIds) async {
    try {
      // First trivia is always unlocked
      if (allTriviaIds.isEmpty || triviaId == allTriviaIds.first) {
        return true;
      }

      // Find the index of the current trivia
      final int currentIndex = allTriviaIds.indexOf(triviaId);
      if (currentIndex <= 0) {
        return false; // Something is wrong with the ID
      }

      // Check if the previous trivia is completed successfully
      final String previousTriviaId = allTriviaIds[currentIndex - 1];
      final TriviaProgress? previousProgress =
          await getTriviaProgress(previousTriviaId);

      // Previous trivia must be completed with a passing score to unlock this one
      return previousProgress != null &&
          previousProgress.completed &&
          previousProgress.passed;
    } catch (e) {
      print('Error checking if trivia is unlocked: $e');
      return false;
    }
  }

  // Clear all progress (for testing)
  Future<void> clearAllProgress() async {
    try {
      await _secureStorage.delete(key: _triviaProgressKey);
    } catch (e) {
      print('Error clearing trivia progress: $e');
    }
  }
}

class TriviaProgress {
  final bool completed;
  final int score;
  final int totalQuestions;
  final bool passed;
  final DateTime completedAt;

  TriviaProgress({
    required this.completed,
    required this.score,
    required this.totalQuestions,
    required this.passed,
    required this.completedAt,
  });

  factory TriviaProgress.fromJson(Map<String, dynamic> json) {
    return TriviaProgress(
      completed: json['completed'] ?? false,
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      passed: json['passed'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completed': completed,
      'score': score,
      'totalQuestions': totalQuestions,
      'passed': passed,
      'completedAt': completedAt.toIso8601String(),
    };
  }
}

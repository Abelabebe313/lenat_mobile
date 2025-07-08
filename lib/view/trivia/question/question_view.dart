import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/trivia/question/question_viewmodel.dart';
import 'widgets/quesiton_result_screen.dart';

class QuestionView extends StatefulWidget {
  final String triviaId;
  final String triviaName;

  const QuestionView({
    super.key,
    required this.triviaId,
    required this.triviaName,
  });

  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  PageController _pageController = PageController();
  Timer? _timer;
  int timerSeconds = 50;
  bool isAnswerSelected = false;
  String? selectedAnswer;
  bool showResult = false;
  QuestionViewModel? _currentViewModel;

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    _timer?.cancel();
    timerSeconds = 50;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds == 0) {
        timer.cancel();
        // Handle timer expiration
        if (_currentViewModel != null) {
          setState(() {
            isAnswerSelected = true;
            selectedAnswer = null;
          });
          // Call the viewmodel method to handle timer expiration
          _currentViewModel!.handleTimerExpiration();
          
          // Wait and then move to next question or show result
          Future.delayed(const Duration(seconds: 2), () {
            if (_currentViewModel!.gameCompleted) {
              setState(() {
                showResult = true;
              });
            } else {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
              setState(() {
                isAnswerSelected = false;
                selectedAnswer = null;
              });
              startTimer();
            }
          });
        }
      } else {
        setState(() {
          timerSeconds--;
        });
      }
    });
  }

  void onAnswerSelected(String? answer, QuestionViewModel viewModel) {
    if (isAnswerSelected) return;

    setState(() {
      isAnswerSelected = true;
      selectedAnswer = answer;
    });

    if (answer != null) {
      viewModel.answerQuestion(answer);
    } else {
      // Time ran out, count as wrong answer
      viewModel.handleTimerExpiration();
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (viewModel.gameCompleted) {
        _timer?.cancel();
        setState(() {
          showResult = true;
        });
      } else {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
        setState(() {
          isAnswerSelected = false;
          selectedAnswer = null;
        });
        startTimer();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final viewModel = QuestionViewModel();
        _currentViewModel = viewModel;
        // Load questions when the provider is created
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.loadQuestions(widget.triviaId, context).then((_) {
            // Start timer after questions are loaded
            if (mounted) {
              startTimer();
            }
          });
        });
        return viewModel;
      },
      child: Consumer<QuestionViewModel>(
        builder: (context, viewModel, child) {
          // Update the current viewModel reference
          _currentViewModel = viewModel;

          // Handle timer expiration
          if (isAnswerSelected &&
              selectedAnswer == null &&
              _currentViewModel != null) {
            // Timer expired, handle the answer
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onAnswerSelected(null, _currentViewModel!);
            });
          }

          if (viewModel.isLoading) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (viewModel.error != null) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${viewModel.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        viewModel.clearError();
                        viewModel.loadQuestions(widget.triviaId, context);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (viewModel.questions.isEmpty) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: const Center(
                child: Text(
                  'No questions available for this trivia',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          if (showResult || viewModel.gameCompleted) {
            return ResultScreen(
              isWinner: viewModel.isWinner,
              score: viewModel.score,
              totalQuestions: viewModel.questions.length,
              onPlayAgain: () {
                viewModel.resetGame();
                setState(() {
                  showResult = false;
                  _pageController = PageController();
                });
                startTimer();
              },
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              elevation: 0,
              title: Text(
                widget.triviaName,
                style: const TextStyle(
                  fontFamily: 'NotoSansEthiopic',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              actions: [
                Row(
                  children: List.generate(3, (i) {
                    return Icon(
                      Icons.favorite,
                      color: i < viewModel.lives
                          ? Colors.red
                          : Colors.grey.shade300,
                    );
                  }),
                ),
                const SizedBox(width: 12)
              ],
            ),
            body: Column(
              children: [
                LinearProgressIndicator(
                  value: timerSeconds / 50,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Primary),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                            "${viewModel.currentQuestionIndex + 1}/${viewModel.questions.length}",
                            style: const TextStyle(color: Colors.grey)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "${(timerSeconds ~/ 60).toString().padLeft(2, '0')}:${(timerSeconds % 60).toString().padLeft(2, '0')}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.questions.length,
                    itemBuilder: (context, index) {
                      final question = viewModel.questions[index];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              question.content ?? 'No question content',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'NotoSansEthiopic',
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (question.hint != null) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.blue.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.lightbulb,
                                        color: Colors.blue.shade600, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Hint: ${question.hint}',
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            ...List.generate(
                              question.options?.length ?? 0,
                              (i) {
                                final option = question.options![i];
                                final isCorrect = option == question.answer;
                                Color? bgColor;
                                Icon? icon;

                                if (isAnswerSelected) {
                                  if (isCorrect) {
                                    bgColor = Primary;
                                    icon = const Icon(Icons.check,
                                        color: Colors.white);
                                  } else if (option == selectedAnswer) {
                                    bgColor = Colors.red;
                                    icon = const Icon(Icons.close,
                                        color: Colors.white);
                                  } else {
                                    bgColor = Colors.grey[300];
                                  }
                                }

                                return GestureDetector(
                                  onTap: () =>
                                      onAnswerSelected(option, viewModel),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: bgColor ?? Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: isAnswerSelected && (bgColor == Primary || bgColor == Colors.red)
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontFamily: 'NotoSansEthiopic',
                                            ),
                                          ),
                                        ),
                                        if (icon != null) icon,
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (isAnswerSelected &&
                                question.explanation != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.green.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info,
                                        color: Colors.green.shade600, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        question.explanation!,
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: ElevatedButton(
                                onPressed: isAnswerSelected ? () {
                                  if (viewModel.gameCompleted) {
                                    _timer?.cancel();
                                    setState(() {
                                      showResult = true;
                                    });
                                  } else {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut);
                                    setState(() {
                                      isAnswerSelected = false;
                                      selectedAnswer = null;
                                    });
                                    startTimer();
                                  }
                                } : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 60,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  "ቀጥል",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontFamily: 'NotoSansEthiopic',
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

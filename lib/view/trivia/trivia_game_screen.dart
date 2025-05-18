import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';

import 'trivia_result_screen.dart';

class TriviaGamePage extends StatefulWidget {
  @override
  _TriviaGamePageState createState() => _TriviaGamePageState();
}

class _TriviaGamePageState extends State<TriviaGamePage> {
  PageController _pageController = PageController();
  int currentPage = 0;
  int lives = 3;
  int timerSeconds = 50;
  Timer? _timer;
  bool isAnswerSelected = false;
  int? selectedIndex;
  bool showResult = false;
  bool isCorrect = false;

  List<Question> questions = [
    Question(
      text:
          "Lorem ipsum dolor sit amet consectetur. Velit mauris etiam tortor adipiscing dis?",
      image:
          "https://images.unsplash.com/photo-1538678867871-8a43e7487746?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      answers: ["Correct answer", "Wrong 1", "Wrong 2", "Wrong 3"],
      correctAnswerIndex: 0,
    ),
    Question(
      text: "Second question?",
      image:
          "https://images.unsplash.com/photo-1567073931033-07972e6081bd?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      answers: ["Wrong 1", "Correct answer", "Wrong 2", "Wrong 3"],
      correctAnswerIndex: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    timerSeconds = 1000;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds == 0) {
        timer.cancel();
        onAnswerSelected(null);
      } else {
        setState(() {
          timerSeconds--;
        });
      }
    });
  }

  void onAnswerSelected(int? index) {
    if (isAnswerSelected) return;

    setState(() {
      isAnswerSelected = true;
      selectedIndex = index;
      isCorrect = index == questions[currentPage].correctAnswerIndex;
      if (!isCorrect) {
        lives--;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (currentPage == questions.length - 1 || lives == 0) {
        _timer?.cancel();
        setState(() {
          showResult = true;
        });
      } else {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
        setState(() {
          currentPage++;
          isAnswerSelected = false;
          selectedIndex = null;
          isCorrect = false;
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
    if (showResult) {
      return ResultScreen(isWinner: lives > 0);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          "የሕፃን እንክብካቤ",
          style: TextStyle(
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
                color: i < lives ? Colors.red : Colors.grey.shade300,
              );
            }),
          ),
          const SizedBox(width: 12)
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: timerSeconds / 1,
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
                  child: Text("${currentPage + 1}/${questions.length}",
                      style: const TextStyle(color: Colors.grey)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "${(timerSeconds ~/ 60).toString().padLeft(2, '0')}:${(timerSeconds % 60).toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          question.image,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        question.text,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(
                        question.answers.length,
                        (i) {
                          Color? bgColor;
                          Icon? icon;

                          if (isAnswerSelected) {
                            if (i == question.correctAnswerIndex) {
                              bgColor = Primary;
                              icon =
                                  const Icon(Icons.check, color: Colors.white);
                            } else if (i == selectedIndex) {
                              bgColor = Colors.red;
                              icon =
                                  const Icon(Icons.close, color: Colors.white);
                            } else {
                              bgColor = Colors.grey[300];
                            }
                          }

                          return GestureDetector(
                            onTap: () => onAnswerSelected(i),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: bgColor ?? Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      question.answers[i],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: isAnswerSelected
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
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          onPressed: isAnswerSelected ? () => {} : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
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
  }
}

class Question {
  final String text;
  final String image;
  final List<String> answers;
  final int correctAnswerIndex;

  Question({
    required this.text,
    required this.image,
    required this.answers,
    required this.correctAnswerIndex,
  });
}

import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/trivia/trivia_game_screen.dart';

class ResultScreen extends StatelessWidget {
  final bool isWinner;

  const ResultScreen({super.key, required this.isWinner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isWinner ? 'assets/images/trophy.png' : 'assets/lose.png',
                height: 200,
              ),
              const SizedBox(height: 24),
              Text(
                isWinner ? 'አሸናፊ ሆነዋል!' : 'አይደለም!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Lorem ipsum dolor sit amet consectetur.\nVelit mauris etiam tortor adipiscing dis?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => TriviaGamePage()),
                    );
                  },
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
                    isWinner ? 'እንደገና' : 'ደግመህ ሞክር',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

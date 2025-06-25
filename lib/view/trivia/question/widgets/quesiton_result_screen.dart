import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';

class ResultScreen extends StatelessWidget {
  final bool isWinner;
  final int score;
  final int totalQuestions;
  final VoidCallback onPlayAgain;

  const ResultScreen({
    super.key, 
    required this.isWinner,
    required this.score,
    required this.totalQuestions,
    required this.onPlayAgain,
  });

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
                isWinner ? 'assets/images/trophy.png' : 'assets/images/trophy.png',
                height: 200,
              ),
              const SizedBox(height: 24),
              Text(
                isWinner ? 'አሸናፊ ሆነዋል!' : 'አይደለም!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'የተገኙት ነጥብ: $score/$totalQuestions',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isWinner 
                  ? 'በጣም ጥሩ ነው! ሁሉንም ጥያቄዎች በትክክል መለሱ።'
                  : 'ደግመህ ሞክር። ለሚቀጥለው ጊዜ የተሻለ ውጤት ያገኛለህ።',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  onPressed: onPlayAgain,
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
                  child: Text(
                    isWinner ? 'እንደገና ለመጫወት' : 'ደግመህ ሞክር',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'ወደ ኋላ ይመለሱ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Primary,
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

import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/trivia/trivia_viewmodel.dart';
import 'package:provider/provider.dart';

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
    final double passPercentage = (score / totalQuestions) * 100;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show trophy only if user passed (score > 50%)
              if (isWinner) ...[
                Image.asset(
                  'assets/images/trophy.png',
                  height: 180,
                ),
              ] else ...[
                Icon(
                  Icons.sentiment_dissatisfied_rounded,
                  size: 120,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 24),
              Text(
                isWinner ? 'አሸናፊ ሆነዋል!' : 'አልተሳካም!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'የተገኙት ነጥብ: $score/$totalQuestions (${passPercentage.toStringAsFixed(0)}%)',
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
                    // Refresh trivia list before popping to show newly unlocked trivias
                    final triviaViewModel =
                        Provider.of<TriviaViewModel>(context, listen: false);
                    triviaViewModel.loadTrivia(context);
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

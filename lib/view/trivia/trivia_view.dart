import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/trivia/trivia_game_screen.dart';

class TriviaView extends StatefulWidget {
  const TriviaView({super.key});

  @override
  State<TriviaView> createState() => _TriviaViewState();
}

class _TriviaViewState extends State<TriviaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "ወደ ኋላ ይመለሱ",
          style: TextStyle(
            fontFamily: 'NotoSansEthiopic',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              "እራሶን ይፈትሹ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSansEthiopic',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "በነዚህ አስተማሪ ጥያቄዎች እራሶን ይፈትሹ!",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            _buildQuestionCatagoryCard(
              'የሕፃናት እንክብካቤ',
              "Lorem ipsum dolor sit amet \nconsectetur. Sagittis id libero.Lorem",
              HugeIcons.strokeRoundedBaby01,
              true,
            ),
            const SizedBox(height: 16),
            _buildQuestionCatagoryCard(
              'ልብስ',
              "Lorem ipsum dolor sit amet \nconsectetur. Sagittis id libero.Lorem",
              HugeIcons.strokeRoundedClothes,
              false,
            ),
            const SizedBox(height: 16),
            _buildQuestionCatagoryCard(
              'ምግብ',
              "Lorem ipsum dolor sit amet \nconsectetur. Sagittis id libero.Lorem",
              HugeIcons.strokeRoundedChefHat,
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCatagoryCard(
    String title,
    String description,
    IconData icon,
    bool status,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: HugeIcon(
              icon: icon,
              color: Colors.black,
              size: 48.0,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSansEthiopic',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '15 ጥያቄዎች',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Primary,
                      fontFamily: 'NotoSansEthiopic',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (status) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TriviaGamePage();
                    }));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "ይቅርታ ይህ ጥያቄ አልተከፈተም",
                          style: TextStyle(
                            fontFamily: 'NotoSansEthiopic',
                            fontSize: 14,
                          ),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: status ? Primary : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                ),
                child: status
                    ? Text(
                        "አሁን ይጫወቱ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'NotoSansEthiopic',
                        ),
                      )
                    : Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

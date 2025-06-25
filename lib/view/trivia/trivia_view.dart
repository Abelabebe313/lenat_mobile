import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/trivia/question/question_view.dart';
import 'package:lenat_mobile/view/trivia/trivia_viewmodel.dart';
import 'package:provider/provider.dart';

class TriviaView extends StatefulWidget {
  const TriviaView({super.key});

  @override
  State<TriviaView> createState() => _TriviaViewState();
}

class _TriviaViewState extends State<TriviaView> {
  @override
  void initState() {
    super.initState();
    // Load trivia data when the view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<TriviaViewModel>(context, listen: false);
      viewModel.loadTrivia(context);
    });
  }

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
      body: Consumer<TriviaViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.error != null) {
            return Center(
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
                      viewModel.loadTrivia(context);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.triviaList.isEmpty) {
            return const Center(
              child: Text(
                'No trivia available',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Padding(
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
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.triviaList.length,
                    itemBuilder: (context, index) {
                      final trivia = viewModel.triviaList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildQuestionCategoryCard(
                          trivia.name ?? 'Unknown',
                          trivia.description ?? 'No description available',
                          _getIconForIndex(index),
                          true, // For now, all trivia are available
                          trivia.questions?.length ?? 0,
                          trivia.id ?? '',
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

  IconData _getIconForIndex(int index) {
    // Map index to different icons for variety
    switch (index) {
      case 0:
        return HugeIcons.strokeRoundedBaby01;
      case 1:
        return HugeIcons.strokeRoundedClothes;
      case 2:
        return HugeIcons.strokeRoundedChefHat;
      default:
        return HugeIcons.strokeRoundedBaby01;
    }
  }

  Widget _buildQuestionCategoryCard(
    String title,
    String description,
    IconData icon,
    bool status,
    int questionCount,
    String triviaId,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSansEthiopic',
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      '$questionCount ጥያቄዎች',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionView(
                            triviaId: triviaId,
                            triviaName: title,
                          ),
                        ),
                      );
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
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AIChatView extends StatefulWidget {
  const AIChatView({super.key});

  @override
  State<AIChatView> createState() => _AIChatViewState();
}

class _AIChatViewState extends State<AIChatView> {
  List chatHistory = [];
  late ChatSession chat;
  ScrollController scrollController = ScrollController();
  TextEditingController userMessageController = TextEditingController();

  // Model Init
  final model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: 'AIzaSyBcPZO3nsbkGhA2fHJpn8ZcxHu9s4tAmsw',
    generationConfig: GenerationConfig(
      temperature: 1,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 8192,
      responseMimeType: 'text/plain',
    ),
    systemInstruction: Content(
      'ai',
      [TextPart('Always respond in Amharic')],
    ),
  );

  void sendTextToAI() async {
    // Clean User Input
    String userInput = userMessageController.text.trim();
    userMessageController.clear();

    // Add to Chat History
    addToChatHistory("User", userInput);

    // Response
    final content = Content.text(userInput);
    var response = await chat.sendMessage(content);
    String aiResponse = response.text!;

    // Add to Chat History
    addToChatHistory("AI", aiResponse.toString().trim());
  }

  // Add to Chat History
  void addToChatHistory(String from, String content) {
    if (from == "AI") {
      chatHistory.removeLast();
    }
    chatHistory.add({
      "from": from,
      "content": content,
    });
    if (from == "User") {
      chatHistory.add({
        "from": 'System',
        "content": 'Loading...',
      });
    }
    setState(() {});
  }

  void clearChat() async {
    chatHistory.clear();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    chat = model.startChat(history: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("የድጋፍ ቻት"),
        actions: [
          // CLEAR CHAT
          IconButton(
            onPressed: () {
              clearChat();
            },
            icon: const Icon(
              Icons.delete_forever_outlined,
            ),
          ),
          const SizedBox(width: 5.0),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10.0),

          Expanded(
            child: chatHistory.isEmpty
                ? ListView(
                    padding: const EdgeInsets.only(top: 100.0),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Icon(
                              Icons.auto_awesome_outlined,
                              size: 30.0,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50.0,
                            ),
                            child: const Text(
                              "This AI conversation is powered by Google's Gemini 1.5 Flash. You can have conversations about pregnancy support here.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: chatHistory.length,
                    itemBuilder: (context, index) {
                      final item = chatHistory[index];
                      final isFromUser = item['from'] == 'User';
                      final isSystem = item['from'] == 'System';
                      return Row(
                        mainAxisAlignment: isFromUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              minWidth: 100.0,
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: isFromUser ? 15.0 : 5.0,
                              vertical: 10.0,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isFromUser ? Primary : Primary.withAlpha(50),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: isSystem
                                ? LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colors.black,
                                    size: 18.0,
                                  )
                                : Text(
                                    item['content'],
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isFromUser
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          // Chat Box and Send Button
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              bottom: 8.0,
              top: 8.0,
            ),
            child: Row(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(right: 0.0),
                //   child: IconButton(
                //     onPressed: () {
                //       // apiKey == "" ? () {} : chatWithAI();
                //     },
                //     icon: Icon(
                //       Icons.attach_file,
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 18.0,
                      right: 18.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.grey[100],
                    ),
                    child: TextField(
                      controller: userMessageController,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "ask about anything...",
                        hintStyle: TextStyle(color: Colors.grey[700]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Primary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: IconButton(
                      onPressed: () {
                        sendTextToAI();
                      },
                      icon: Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                      ),
                    ),
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

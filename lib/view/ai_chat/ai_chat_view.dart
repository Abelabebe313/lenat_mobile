import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';

class AIChatView extends StatefulWidget {
  const AIChatView({super.key});

  @override
  State<AIChatView> createState() => _AIChatViewState();
}

class _AIChatViewState extends State<AIChatView> {
  TextEditingController userMessageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List sampleChat = [
    {
      "from": "User",
      "content": "Hello!",
    },
    {
      "from": "AI",
      "content": "Hello there",
    },
    {
      "from": "User",
      "content":
          "እንኳን ወደ እኛ በደህና መጡ! የደንበኞቻችን የድጋፍ ቻትቦት ይገኛል! እንዴት ልንረዳት እንችላለን? ከታች አማራጭ ይምረጡ። 😁",
    },
    {
      "from": "AI",
      "content":
          "ይቅርታ! ይህ ጽሁፍ የተሳሳተ ነው። እባኮትን እንደ ገና ይጻፉ። ይቅርታ! ይህ ጽሁፍ የተሳሳተ ነው። እባኮትን እንደ ገና ይጻፉ። ይቅርታ! ይህ ጽሁፍ የተሳሳተ ነው። እባኮትን እንደ ገና ይጻፉ። ይቅርታ! ይህ ጽሁፍ የተሳሳተ ነው። እባኮትን እንደ ገና ይጻፉ። ",
    },
    {
      "from": "User",
      "content": "Hello!",
    },
    {
      "from": "AI",
      "content": "Hello there",
    },
  ];

  void clearChat() async {
    sampleChat.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
            child: sampleChat.isEmpty
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
                    itemCount: sampleChat.length,
                    itemBuilder: (context, index) {
                      final item = sampleChat[index];
                      final isFromUser = item['from'] == 'User';
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
                            child: Text(
                              item['content'],
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isFromUser ? Colors.white : Colors.black,
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
                        // apiKey == "" ? () {} : chatWithAI();
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

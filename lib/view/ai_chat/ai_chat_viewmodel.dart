import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AiChatViewModel extends ChangeNotifier {
  String modelName = "";
  String apiKey = "";
  List chatHistory = [];
  late ChatSession chat;
  ScrollController scrollController = ScrollController();
  TextEditingController userMessageController = TextEditingController();
  String? imageBase64;

  String getAPIKeyQuery = r'''
    query GetAPIKey {
      ai_models {
        id
        model_name
        api_key
      }
    }
  ''';

  Future<void> fetchAPIKey(BuildContext context) async {
    final client = GraphQLProvider.of(context).value;

    final result = await client.query(
      QueryOptions(document: gql(getAPIKeyQuery)),
    );

    if (result.hasException) {
      print(result.exception.toString());
    } else {
      modelName = result.data!["ai_models"][0]["model_name"];
      apiKey = result.data!["ai_models"][0]["api_key"];
      notifyListeners();
    }
  }

  // Model Init
  var model = GenerativeModel(apiKey: "", model: "");
  void initiateModel(context) async {
    // Fetch API
    await fetchAPIKey(context);
    // Init Model
    model = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
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
    chat = model.startChat(history: []);
  }

  void sendTextToAI() async {
    // Clean User Input
    String userInput = userMessageController.text.trim();
    userMessageController.clear();

    String formattedUserInput = userInput +
        (imageBase64 != null ? ". Associated Image: $imageBase64" : "");

    // Add to Chat History
    addToChatHistory("User", userInput, imageBase64!);

    // Response
    final content = Content.text(formattedUserInput);
    var response = await chat.sendMessage(content);
    String aiResponse = response.text!;

    // Add to Chat History
    addToChatHistory("AI", aiResponse.toString().trim(), "");
  }

  // Add to Chat History
  void addToChatHistory(String from, String content, String image) {
    if (from == "AI") {
      chatHistory.removeLast();
    }
    chatHistory.add({
      "from": from,
      "content": content,
      "image": image,
    });
    if (from == "User") {
      chatHistory.add({
        "from": 'System',
        "content": 'Loading...',
      });
    }
    notifyListeners();
  }

  void clearChat() async {
    chatHistory.clear();
    notifyListeners();
  }

  Future<String?> xFileToBase64(XFile? file) async {
    if (file == null) return null;

    Uint8List bytes = await file.readAsBytes();
    String base64Image = base64Encode(bytes);
    return base64Image;
  }
}

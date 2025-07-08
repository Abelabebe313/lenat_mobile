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
  var imageBytes;
  var attachmentData;
  var attachmentMime;

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

    String formattedUserInput = userInput;
    //  + (imageBase64 != null ? ". Associated Image: $imageBase64" : "");

    // Add to Chat History
    addToChatHistory("User", userInput, imageBase64);

    // Response
    var content;
    if (attachmentData != null) {
      content = Content.multi([
        TextPart(formattedUserInput),
        DataPart(attachmentMime, attachmentData!),
      ]);
    } else {
      content = Content.text(formattedUserInput);
    }
    var response = await chat.sendMessage(content);
    String aiResponse = response.text!;
    clearAttachmentData();

    // Add to Chat History
    addToChatHistory("AI", aiResponse.toString().trim(), "");
  }

  // Add to Chat History
  void addToChatHistory(String from, String content, String? image) {
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
    clearImageSelected();
    notifyListeners();
  }

  void clearChat() async {
    chatHistory.clear();
    notifyListeners();
  }

  void selectImage() async {
    var imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    imageBase64 = await xFileToBase64(image);
    notifyListeners();
  }

  void clearImageSelected() async {
    imageBase64 = null;
    notifyListeners();
  }

  void clearAttachmentData() async {
    attachmentData = null;
    notifyListeners();
  }

  Future<String?> xFileToBase64(XFile? file) async {
    if (file == null) return null;
    attachmentMime = _determineMimeType(file.path.split('.').last);
    attachmentData = await file.readAsBytes();

    imageBytes = await file.readAsBytes();

    Uint8List bytes = await file.readAsBytes();
    String base64Image = base64Encode(bytes);
    return base64Image;
  }

  String _determineMimeType(String? extension) {
    if (extension == null) return 'application/octet-stream';

    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'txt':
        return 'text/plain';
      case 'csv':
        return 'text/csv';
      case 'mp3':
        return 'audio/mpeg';
      case 'm4a':
        return 'audio/m4a';
      default:
        return 'application/octet-stream';
    }
  }
}

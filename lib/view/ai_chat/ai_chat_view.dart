import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:lenat_mobile/view/ai_chat/ai_chat_viewmodel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class AIChatView extends StatefulWidget {
  const AIChatView({super.key});

  @override
  State<AIChatView> createState() => _AIChatViewState();
}

class _AIChatViewState extends State<AIChatView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AiChatViewModel>().initiateModel(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AiChatViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("የለእናት ኤአይ (AI) አማካራ"),
            actions: [
              // CLEAR CHAT
              IconButton(
                onPressed: () {
                  viewModel.clearChat();
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
                child: viewModel.chatHistory.isEmpty
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
                                child: Text(
                                  "This AI conversation is powered by ${viewModel.modelName}. You can have conversations about pregnancy support here.",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : ListView.builder(
                        controller: viewModel.scrollController,
                        itemCount: viewModel.chatHistory.length,
                        itemBuilder: (context, index) {
                          final item = viewModel.chatHistory[index];
                          final isFromUser = item['from'] == 'User';
                          final isSystem = item['from'] == 'System';
                          return Column(
                            crossAxisAlignment: isFromUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              // Media
                              isFromUser &&
                                      viewModel.chatHistory[index]["image"] !=
                                          null &&
                                      viewModel.chatHistory[index]["image"] !=
                                          ""
                                  ? GestureDetector(
                                      onTap: () {
                                        final imageProvider = MemoryImage(
                                          base64Decode(
                                            viewModel.chatHistory[index]
                                                ["image"],
                                          ),
                                        );
                                        showImageViewer(context, imageProvider,
                                            onViewerDismissed: () {
                                          print("dismissed");
                                        });
                                      },
                                      child: Container(
                                        width: 100.0,
                                        margin: EdgeInsets.only(right: 20.0),
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: Image.memory(
                                          base64Decode(
                                            viewModel.chatHistory[index]
                                                ["image"],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              // Text
                              Row(
                                mainAxisAlignment: isFromUser
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      minWidth: 100.0,
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.75,
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
                                      color: isFromUser
                                          ? Primary
                                          : Primary.withAlpha(50),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: isSystem
                                        ? LoadingAnimationWidget
                                            .staggeredDotsWave(
                                            color: Colors.black,
                                            size: 18.0,
                                          )
                                        : Text(
                                            item['content'],
                                            // maxLines: 5,
                                            // overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: isFromUser
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
              ),
              // Chat Box and Send Button
              Column(
                children: [
                  viewModel.imageBase64 != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 100.0,
                                  margin: EdgeInsets.only(
                                    left: 20.0,
                                    bottom: 10.0,
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Image.memory(
                                    base64Decode(
                                      viewModel.imageBase64!,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      viewModel.clearImageSelected();
                                      viewModel.clearAttachmentData();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(100),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Icon(
                                        Icons.delete_outline_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      bottom: 8.0,
                      top: 8.0,
                    ),
                    child: Row(
                      children: [
                        // Attach
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: IconButton(
                            onPressed: () async {
                              viewModel.selectImage();
                            },
                            icon: Icon(
                              Icons.attach_file,
                            ),
                          ),
                        ),

                        // Input Box
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
                              controller: viewModel.userMessageController,
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

                        // Send Button
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Primary,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: IconButton(
                              onPressed: () {
                                viewModel.sendTextToAI();
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
            ],
          ),
        );
      },
    );
  }
}

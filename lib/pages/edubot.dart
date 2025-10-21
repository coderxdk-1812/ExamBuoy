import 'package:exambuoy_trial/data/repo/gemini_api.dart';
import 'package:exambuoy_trial/pages/revision.dart';
import 'package:exambuoy_trial/widgets/animated_markdown.dart';
import 'package:exambuoy_trial/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isDarkMode = true;
  bool _isLoading = false;
  String _selectedModel = "EduBot Smart";
  final List<String> _models = [
    "EduBot Smart",
    "EduBot Pro",
    "EduBot Advanced"
  ];

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
        geminiApi.chat.add({
          "role": "user",
          "parts": [
            {"text": _controller.text.trim()},
          ]
        });
      });
      _controller.clear();

      // Scroll to bottom after sending message
      Future.delayed(Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

      await geminiApi.chatWithGemini();

      setState(() {
        _isLoading = false;
      });

      // Scroll to show the response
      Future.delayed(Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  late GeminiApi geminiApi;
  @override
  void initState() {
    geminiApi = GeminiApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isDarkMode ? Color(0xFF1A1A1A) : Color(0xFFE8F5E9);
    final textColor = _isDarkMode ? Color(0xFFFFFFFF) : Color(0xFF1A1A1A);
    final cardColor = _isDarkMode ? Color(0xFF2A2A2A) : Color(0xFFFFFFFF);
    final userMessageColor =
        _isDarkMode ? Color(0xFF3A3A3A) : Color(0xFFE0E0E0);
    final aiMessageColor = _isDarkMode ? Color(0xFF2D2D2D) : Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            Icon(Icons.school_outlined, color: textColor, size: 24),
            SizedBox(width: 12),
            Text(
              "EduBot",
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.model_training_outlined, color: textColor),
            onSelected: (String value) {
              setState(() {
                _selectedModel = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return _models.map((String model) {
                return PopupMenuItem<String>(
                  value: model,
                  child: Row(
                    children: [
                      if (model == _selectedModel)
                        Icon(Icons.check, size: 18, color: Colors.green),
                      if (model == _selectedModel) SizedBox(width: 8),
                      Text(model),
                    ],
                  ),
                );
              }).toList();
            },
          ),
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: textColor),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.quiz_outlined, color: textColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RevisionPage()),
              );
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Main chat area
          Expanded(
            child: ListenableBuilder(
              listenable: geminiApi,
              builder: (context, widget) {
                if (geminiApi.chat.isEmpty) {
                  // Welcome screen
                  return Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // AI Avatar
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF4CAF50),
                                  Color(0xFF81C784),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF4CAF50).withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.psychology_outlined,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 32),
                          Text(
                            "Good ${_getGreeting()}!",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Can I help you with anything?",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Choose a prompt below or write your own to start\nchatting with EduBot",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 40),
                          // Prompt suggestions
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildPromptButton(
                                "Get fresh perspectives on\ntricky problems",
                                textColor,
                                cardColor,
                              ),
                              _buildPromptButton(
                                "Brainstorm creative ideas",
                                textColor,
                                cardColor,
                              ),
                              _buildPromptButton(
                                "Summarize the book\nAtomic Habits",
                                textColor,
                                cardColor,
                              ),
                              _buildPromptButton(
                                "Explain Einstein's theory\nof relativity",
                                textColor,
                                cardColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          // TextButton.icon(
                          //   onPressed: _refreshPrompts,
                          //   icon: Icon(Icons.refresh,
                          //       color: textColor.withOpacity(0.6)),
                          //   label: Text(
                          //     "Refresh prompts",
                          //     style: TextStyle(
                          //       color: textColor.withOpacity(0.6),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  );
                }

                // Chat messages
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: geminiApi.chat.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show loading indicator at the end
                    if (_isLoading && index == geminiApi.chat.length) {
                      return AILoadingWidget(
                        avatarColor: Color(0xFF4CAF50),
                        icon: Icons.psychology_outlined,
                        message: "EduBot is crafting your response...",
                        textColor: textColor,
                      );
                    }
                    final isUser = geminiApi.chat[index]['role'] == 'user';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isUser) ...[
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF4CAF50),
                                    Color(0xFF81C784)
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.psychology_outlined,
                                  color: Colors.white, size: 20),
                            ),
                            SizedBox(width: 12),
                          ],
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    isUser ? userMessageColor : aiMessageColor,
                                borderRadius: BorderRadius.circular(16),
                                border: !isUser
                                    ? Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1,
                                      )
                                    : null,
                              ),
                              child: isUser
                                  ? Text(
                                      geminiApi.chat[index]['parts'][0]['text'],
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 15,
                                      ),
                                    )
                                  : (index == geminiApi.chat.length - 1 &&
                                          geminiApi.chat[index]['role'] ==
                                              'model')
                                      ? AnimatedMarkdown(
                                          data: geminiApi.chat[index]['parts']
                                              [0]['text'],
                                          textStyle: TextStyle(
                                            fontSize: 15.0,
                                            color: textColor,
                                          ),
                                          speed:
                                              const Duration(milliseconds: 20),
                                        )
                                      : StaticMarkdown(
                                          data: geminiApi.chat[index]['parts']
                                              [0]['text'],
                                          textStyle: TextStyle(
                                            fontSize: 15.0,
                                            color: textColor,
                                          ),
                                        ),
                            ),
                          ),
                          if (isUser) ...[
                            SizedBox(width: 12),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Color(0xFF4CAF50),
                              child: Icon(Icons.person,
                                  color: Colors.white, size: 20),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Input area
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              style: TextStyle(color: textColor, fontSize: 15),
                              maxLines: null,
                              textInputAction: TextInputAction.send,
                              decoration: InputDecoration(
                                hintText: "How can EduBot help you today?",
                                hintStyle: TextStyle(
                                  color: textColor.withOpacity(0.5),
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12),
                              ),
                              onSubmitted: (value) {
                                _sendMessage();
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(Icons.arrow_upward, color: Colors.white),
                      padding: EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Model selector at bottom
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: cardColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$_selectedModel",
                  style: TextStyle(
                    color: textColor.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.verified, color: Colors.blue, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptButton(String text, Color textColor, Color cardColor) {
    return InkWell(
      onTap: () async {
        setState(() {
          _isLoading = true;
          geminiApi.chat.add({
            "role": "user",
            "parts": [
              {"text": text.replaceAll('\n', ' ')}
            ],
          });
        });

        // Scroll to bottom
        Future.delayed(Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });

        await geminiApi.chatWithGemini();

        setState(() {
          _isLoading = false;
        });

        // Scroll to show the response
        Future.delayed(Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}

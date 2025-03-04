import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:exambuoy_trial/data/repo/gemini_api.dart';
import 'package:exambuoy_trial/pages/revision.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        geminiApi.chat.add({
          "role": "user",
          "parts": [
            {"text": _controller.text.trim()},
          ]
        });
      });
      geminiApi.chatWithGemini();
      _controller.clear();
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        return Scaffold(
          appBar: AppBar(
            title: Stack(
              children: [
                Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, color: Color(0xFFEFF1ED)),
                    SizedBox(width: 8),
                    Text(
                      "StudyBuddy",
                      style: TextStyle(color: Color(0xFFEFF1ED)),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    isSmallScreen ? "EduBot" : "EduBot",
                    style: TextStyle(color: Color(0xFFEFF1ED)),
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF304246),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RevisionPage()),
                  );
                },
                child: Text(
                  "Revision Questions",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            backgroundColor: Color(0xFF0F272F),
          ),
          body: Stack(
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/mainbg.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  ListenableBuilder(
                    listenable: geminiApi,
                    builder: (context, widget) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: geminiApi.chat.length,
                          itemBuilder: (context, index) {
                            final isUser =
                                geminiApi.chat[index]['role'] == 'user';
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: isUser
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth *
                                        (isSmallScreen ? 0.9 : 0.75),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isUser
                                        ? Color(0xFF304246)
                                        : Color(0xFF0F272F),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: isUser
                                      ? Text(
                                          geminiApi.chat[index]['parts'][0]
                                              ['text'],
                                          style: TextStyle(
                                            color: Color(0xFFEFF1ED),
                                          ),
                                        )
                                      : AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                              geminiApi.chat[index]['parts'][0]
                                                  ['text'],
                                              textStyle: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFEFF1ED),
                                              ),
                                              speed: const Duration(
                                                  milliseconds: 20),
                                            ),
                                          ],
                                          totalRepeatCount: 1,
                                          displayFullTextOnTap: true,
                                          stopPauseOnTap: true,
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 8.0 : 16.0),
                    child: Wrap(
                      spacing: isSmallScreen ? 8 : 20,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              geminiApi.chat.add({
                                "role": "user",
                                "parts": [
                                  {
                                    "text":
                                        "Summarize the book Atomic Habits by James Clear."
                                  },
                                ]
                              });
                              geminiApi.chatWithGemini();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFEFF1ED),
                            ),
                            child: Text(
                              "Summarize the book Atomic Habits by James Clear.",
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              geminiApi.chat.add({
                                "role": "user",
                                "parts": [
                                  {
                                    "text":
                                        "Give me a quick summary of the French Revolution."
                                  },
                                ]
                              });
                              geminiApi.chatWithGemini();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFEFF1ED),
                            ),
                            child: Text(
                              "Give me a quick summary of the French Revolution.",
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              geminiApi.chat.add({
                                "role": "user",
                                "parts": [
                                  {
                                    "text":
                                        "Explain Einstein's theory of relativity in simple terms."
                                  },
                                ]
                              });
                              geminiApi.chatWithGemini();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFEFF1ED),
                            ),
                            child: Text(
                              "Explain Einstein's theory of relativity in simple terms.",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 4.0 : 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 4.0 : 8.0),
                            child: TextField(
                              controller: _controller,
                              style: TextStyle(
                                color: Color(0xFFEFF1ED),
                              ),
                              decoration: InputDecoration(
                                hintText: "Type your message...",
                                hintStyle: TextStyle(color: Color(0xFFEFF1ED)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onSubmitted: (value) {
                                _focusNode.unfocus(); // Unfocus the input field
                                _sendMessage();
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 4 : 8),
                        IconButton(
                          onPressed: () {
                            _sendMessage();
                          },
                          icon:
                              const Icon(Icons.send, color: Color(0xFFEFF1ED)),
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

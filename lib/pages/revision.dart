import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:exambuoy_trial/data/repo/gemini_api.dart';
import 'package:flutter/material.dart';

List<String> list = <String>['Easy', 'Medium', 'Hard'];
List<String> list2 = <String>[
  'Grade 1',
  'Grade 2',
  'Grade 3',
  'Grade 4',
  'Grade 5',
  'Grade 6',
  'Grade 7',
  'Grade 8',
  'Grade 9',
  'Grade 10',
  'Grade 11',
  'Grade 12',
  'College Undergraduate Level',
  'College Graduate Level'
];
List<String> list3 = <String>[
  '1-5',
  '5-10',
  '10-15',
  '15-20',
  '20-25',
  '25-30',
  '30-35',
  '35-40'
];
List<String> list4 = <String>['Mathematics', 'Physics', 'Chemistry', 'Biology'];

class RevisionPage extends StatefulWidget {
  const RevisionPage({super.key});

  @override
  State<RevisionPage> createState() => _RevisionPageState();
}

class _RevisionPageState extends State<RevisionPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? dificultyValue;
  String? dropdownValue2;
  String? numQuestions;
  String? subject;
  bool _isDarkMode = true;
  String _selectedModel = "RevisionBot Smart";
  final List<String> _models = [
    "RevisionBot Smart",
    "RevisionBot Pro",
    "RevisionBot Advanced"
  ];

  void _sendMessage() {
    if (_controller.text.isNotEmpty &&
        subject != null &&
        dificultyValue != null &&
        dropdownValue2 != null &&
        numQuestions != null) {
      setState(() {
        geminiApi.chat.add({
          "role": "user",
          "parts": [
            {
              "text":
                  "Generate ${numQuestions} questions for the subject ${subject}, focusing on the topic(s) ${_controller.text.trim()}. The difficulty level should be ${dificultyValue}, and the questions should be at ${dropdownValue2} level."
            },
          ]
        });
      });
      geminiApi.revisionWithGemini();
      _controller.clear();

      // Scroll to bottom after sending message
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Please fill in all fields before generating questions'),
          backgroundColor: Colors.orange,
        ),
      );
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Icon(Icons.quiz_outlined, color: textColor, size: 24),
            SizedBox(width: 12),
            Text(
              "Revision Questions",
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
                                  Color(0xFF6A1B9A),
                                  Color(0xFFAB47BC),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF6A1B9A).withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.auto_awesome,
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
                            "Generate Practice Questions",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Fill in the parameters below to generate\ncustomized revision questions",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 40),
                          Text(
                            "Configure Your Questions",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  );
                }

                // Chat messages
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: geminiApi.chat.length,
                  itemBuilder: (context, index) {
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
                                    Color(0xFF6A1B9A),
                                    Color(0xFFAB47BC)
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.auto_awesome,
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
                                  : AnimatedTextKit(
                                      animatedTexts: [
                                        TypewriterAnimatedText(
                                          geminiApi.chat[index]['parts'][0]
                                              ['text'],
                                          textStyle: TextStyle(
                                            fontSize: 15.0,
                                            color: textColor,
                                          ),
                                          speed:
                                              const Duration(milliseconds: 20),
                                        ),
                                      ],
                                      totalRepeatCount: 1,
                                      displayFullTextOnTap: true,
                                      stopPauseOnTap: true,
                                    ),
                            ),
                          ),
                          if (isUser) ...[
                            SizedBox(width: 12),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Color(0xFF6A1B9A),
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
          // Parameters and input area
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Parameters in a grid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen = constraints.maxWidth < 700;

                      if (isSmallScreen) {
                        // Vertical layout for small screens
                        return Column(
                          children: [
                            _buildDropdown("Subject", subject, list4, (value) {
                              setState(() => subject = value);
                            }, textColor, backgroundColor),
                            SizedBox(height: 12),
                            _buildTextField(textColor, backgroundColor),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDropdown(
                                      "Difficulty", dificultyValue, list,
                                      (value) {
                                    setState(() => dificultyValue = value);
                                  }, textColor, backgroundColor),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildDropdown(
                                      "Grade", dropdownValue2, list2, (value) {
                                    setState(() => dropdownValue2 = value);
                                  }, textColor, backgroundColor),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDropdown(
                                      "Questions", numQuestions, list3,
                                      (value) {
                                    setState(() => numQuestions = value);
                                  }, textColor, backgroundColor),
                                ),
                                SizedBox(width: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF6A1B9A),
                                        Color(0xFF8E24AA)
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: _sendMessage,
                                    icon: Icon(Icons.auto_awesome,
                                        color: Colors.white),
                                    padding: EdgeInsets.all(12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        // Horizontal layout for larger screens
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDropdown(
                                      "Subject", subject, list4, (value) {
                                    setState(() => subject = value);
                                  }, textColor, backgroundColor),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: _buildTextField(
                                      textColor, backgroundColor),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildDropdown(
                                      "Difficulty", dificultyValue, list,
                                      (value) {
                                    setState(() => dificultyValue = value);
                                  }, textColor, backgroundColor),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDropdown(
                                      "Grade Level", dropdownValue2, list2,
                                      (value) {
                                    setState(() => dropdownValue2 = value);
                                  }, textColor, backgroundColor),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildDropdown("Number of Questions",
                                      numQuestions, list3, (value) {
                                    setState(() => numQuestions = value);
                                  }, textColor, backgroundColor),
                                ),
                                SizedBox(width: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF6A1B9A),
                                        Color(0xFF8E24AA)
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: _sendMessage,
                                    icon: Icon(Icons.auto_awesome,
                                        color: Colors.white),
                                    padding: EdgeInsets.all(12),
                                    tooltip: "Generate Questions",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
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

  Widget _buildTextField(Color textColor, Color backgroundColor) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        style: TextStyle(color: textColor, fontSize: 15),
        decoration: InputDecoration(
          hintText: "Topic of focus...",
          hintStyle: TextStyle(
            color: textColor.withOpacity(0.5),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
    Color textColor,
    Color backgroundColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: value,
        hint: Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.5),
            fontSize: 14,
          ),
        ),
        isExpanded: true,
        underline: SizedBox(),
        dropdownColor: backgroundColor,
        icon: Icon(Icons.arrow_drop_down, color: textColor),
        style: TextStyle(color: textColor, fontSize: 14),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
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

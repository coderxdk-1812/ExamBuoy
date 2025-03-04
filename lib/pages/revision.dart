import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:exambuoy_trial/data/repo/gemini_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
  String? dificultyValue;
  String? dropdownValue2;
  String? numQuestions;
  String? subject;

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFFEFF1ED)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
                    isSmallScreen ? "QGen" : "Question Generator",
                    style: TextStyle(color: Color(0xFFEFF1ED)),
                  ),
                ),
              ],
            ),
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
                  Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 4.0 : 8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: isSmallScreen ? 16 : 20),
                          DropdownButton<String>(
                            borderRadius: BorderRadius.circular(10),
                            hint: Text("Subject",
                                style: TextStyle(color: Colors.white)),
                            value: subject,
                            dropdownColor: Color(0xFF0F272F),
                            onChanged: (String? newValue) {
                              setState(() {
                                subject = newValue!;
                              });
                            },
                            items: list4
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(width: isSmallScreen ? 32 : 50),
                          SizedBox(
                            width: constraints.maxWidth *
                                (isSmallScreen ? 0.3 : 0.32),
                            child: TextField(
                              controller: _controller,
                              style: TextStyle(color: Color(0xFFEFF1ED)),
                              decoration: InputDecoration(
                                hintText: "Topic of focus...",
                                hintStyle: TextStyle(color: Color(0xFFEFF1ED)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 32 : 50),
                          DropdownButton<String>(
                            borderRadius: BorderRadius.circular(10),
                            hint: Text("Difficulty",
                                style: TextStyle(color: Colors.white)),
                            value: dificultyValue,
                            dropdownColor: Color(0xFF0F272F),
                            onChanged: (String? newValue) {
                              setState(() {
                                dificultyValue = newValue!;
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(width: isSmallScreen ? 32 : 50),
                          DropdownButton<String>(
                            value: dropdownValue2,
                            borderRadius: BorderRadius.circular(10),
                            hint: Text("Grade Level",
                                style: TextStyle(color: Colors.white)),
                            dropdownColor: Color(0xFF0F272F),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue2 = newValue!;
                              });
                            },
                            items: list2
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(width: isSmallScreen ? 32 : 50),
                          DropdownButton<String>(
                            value: numQuestions,
                            borderRadius: BorderRadius.circular(10),
                            hint: Text("Questions",
                                style: TextStyle(color: Colors.white)),
                            dropdownColor: Color(0xFF0F272F),
                            onChanged: (String? newValue) {
                              setState(() {
                                numQuestions = newValue!;
                              });
                            },
                            items: list3
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(width: isSmallScreen ? 32 : 50),
                          IconButton(
                            onPressed: () {
                              _sendMessage();
                            },
                            icon: const Icon(Icons.send,
                                color: Color(0xFFEFF1ED)),
                          ),
                        ],
                      ),
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

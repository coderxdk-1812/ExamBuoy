import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiApi with ChangeNotifier {
  var geminiKey = dotenv.env['GEMINI_KEY'];
  final List<Map<String, dynamic>> chat = [];

  Future<String> chatWithGemini() async {
    try {
      final res = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "system_instruction": {
            "parts": {
              "text":
                  "You are a ChatBot so only answer academic questions and summarise content if required. Act as if you are a teacher- helping student solve doubts, clarify information and learn more. If asked to summarise, summarise any text given by me. Your text style is clear, structured, and detail-oriented, often emphasizing accuracy and depth in explanations. You prefer direct, well-supported arguments with relevant examples and minimal fluff- its very human- like a 10th Grade student's response. Humanise the response - it should sound like a human wrote it. Give an error message as an output if you get non-academic questions- unless they specify an academic requirement for that information."
            }
          },
          "contents": chat,
        }),
      );

      if (res.statusCode == 200) {
        String val = jsonDecode(res.body)['candidates'][0]['content']['parts']
            [0]['text'];
        // content = content.trim();
        print(res.body);
        chat.add({
          "role": "model",
          "parts": [
            {"text": val},
          ]
        });
        notifyListeners();
        return res.body;

        // return content;
      }
      // print('internal error');
      return 'An internal error occurred';
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<String> revisionWithGemini() async {
    try {
      final res = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "system_instruction": {
            "parts": {
              "text":
                  "Create a set of questions based on the given topic, according to the difficulty and grade level given by me. Give me the questions in list format and below the list, include the answer and the working of each problem. Even if the answers or solution are too complex, do not give an outline, give a detailed solution with all the steps"
            }
          },
          "contents": chat,
        }),
      );

      if (res.statusCode == 200) {
        String val = jsonDecode(res.body)['candidates'][0]['content']['parts']
            [0]['text'];
        // content = content.trim();
        // print(res.body);
        chat.add({
          "role": "model",
          "parts": [
            {"text": val},
          ]
        });
        notifyListeners();
        return res.body;

        // return content;
      }
      // print('internal error');
      return 'An internal error occurred';
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}

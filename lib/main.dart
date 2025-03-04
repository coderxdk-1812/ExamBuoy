import 'package:exambuoy_trial/pages/edubot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      title: 'StudyBuddy',
      theme: ThemeData(
        primaryColor:
            Color(0xFF1C2541), // Set the primary color to the desired hex code
      ),
      home: const ChatPage(),
    );
  }
}

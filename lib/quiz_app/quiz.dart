import 'package:first_app/quiz_app/question_screen.dart';
import 'package:first_app/quiz_app/quiz_app.dart';
import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  Widget? activeScreen;

  @override
  void initState() {
    super.initState();
    activeScreen = const QuestionScreen();
  }

  void switchScreen() {
    setState(() {
      activeScreen = const QuestionScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundQuiz(children: <Widget>[?activeScreen]);
  }
}

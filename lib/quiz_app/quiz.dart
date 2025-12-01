import 'package:first_app/quiz_app/question_screen.dart';
import 'package:first_app/quiz_app/quiz_app.dart';
import 'package:first_app/quiz_app/result_screen.dart';
import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  Quiz({super.key});

  final List<Map<String, String>> choosenAnswers = [];

  Quiz.result(List<Map<String, String>> choosenAnswers, {super.key}) {
    this.choosenAnswers.addAll(choosenAnswers);
  }
  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  late Widget activeScreen;

  @override
  void initState() {
    super.initState();
    activeScreen = const QuestionScreen();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.choosenAnswers.isNotEmpty) {
      activeScreen = ResultScreen(choosenAnswers: widget.choosenAnswers);
    }
    
    return AppBackgroundQuiz(children: <Widget>[activeScreen]);
  }
}

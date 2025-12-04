import 'dart:math';
import 'package:first_app/main.dart';
import 'package:first_app/quiz_app/models/answer_button.dart';
import 'package:first_app/quiz_app/models/quiz_question.dart';
import 'package:first_app/quiz_app/quiz.dart';
import 'package:first_app/quiz_app/util/app_circle_loading_custom.dart';
import 'package:first_app/quiz_app/util/app_metrics.dart';
import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() {
    return _QuestionScreenState();
  }
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<QuizQuestion>? questions;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final q = await QuizQuestion.fetchQuestions();
      if (mounted) {
        setState(() {
          questions = q;
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  var count = 0;

  List<Map<String, String>> choosenAnswers = [];

  void onSelectAnswer(QuizQuestion currentQuestion, String shuffedList) {
    choosenAnswers.add({
      "question_index": (count + 1).toString(),
      "question": currentQuestion.questionText,
      "correct_answer": currentQuestion.correctAnswer,
      "user_answer": shuffedList,
    });
    if (count < questions!.length - 1) {
      setState(() {
        count++;
        // choosenAnswers.add(value)
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RootScaffold(Quiz.result(choosenAnswers)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions == null) {
      return const Center(child: CircularProgressWithText(8.0));
    }
    final QuizQuestion currentQuestion = questions![count];

    final List<String> listOptions = currentQuestion.getShuffedList;
    // bất kỳ chỗ nào cần
    final top = AppMetrics.instance.totalTopHeight;
    // hoặc chỉ toolbar:
    final toolbar = AppMetrics.instance.appBarHeight;

    return Expanded(
      child: SizedBox(
        // height: MediaQuery.sizeOf(context).height - top - toolbar,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              // width: double.maxFinite,
              widthFactor: 0.5,
              child: Text(
                'Question ${count + 1}: ${top} ** ${toolbar}  ** ${MediaQuery.sizeOf(context).height - top} \n ${currentQuestion.questionText}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  color: const Color.fromARGB(251, 255, 255, 255),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: listOptions.length,
                itemBuilder: (context, index) {
                  return AnswerButton(listOptions[index], () {
                    onSelectAnswer(currentQuestion, listOptions[index]);
                  });
                },

                // children: [
                //   ...currentQuestion.getShuffedList().map((answer) {
                //     return AnswerButton(answer, () {
                //       onSelectAnswer();
                //     });
                //   }),
                // ],
              ),
            ),
            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}

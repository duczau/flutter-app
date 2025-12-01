import 'package:first_app/main.dart';
import 'package:first_app/quiz_app/data/question.dart';
import 'package:first_app/quiz_app/models/answer_button.dart';
import 'package:first_app/quiz_app/models/quiz_question.dart';
import 'package:first_app/quiz_app/quiz.dart';
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
  var count = 0;

  List<Map<String, String>> choosenAnswers = [{
    "question_index": "0",
    "question": "What is the capital of France?",
    "correct_answer": "Paris",
    "user_answer": "Paris",
  },
  {
    "question_index": "1",
    "question": "What is 2 + 2?",
    "correct_answer": "4",
    "user_answer": "2",
  },
  {
    "question_index": "2",
    "question": "What is the largest planet in our solar system?",
    "correct_answer": "Jupiter",
    "user_answer": "zzz",
  },
  {
    "question_index": "3",
    "question": "Who wrote 'Romeo and Juliet'?",
    "correct_answer": "William Shakespeare",
    "user_answer": "William Shakespeare",
  }
  ];

  void onSelectAnswer() {
    if (count < questions.length - 1) {
      setState(() {
        count++;
        // choosenAnswers.add(value)
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RootScaffold(Quiz.result(choosenAnswers))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final QuizQuestion currentQuestion = questions[count];
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
                itemCount: currentQuestion.getShuffedList().length,
                itemBuilder: (context, index) {
                  return AnswerButton(
                    currentQuestion.getShuffedList()[index],
                    () {
                      onSelectAnswer();
                    },
                  );
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

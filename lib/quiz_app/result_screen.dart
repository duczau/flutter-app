import 'package:first_app/quiz_app/data/question.dart';
import 'package:first_app/quiz_app/models/quiz_question.dart';
import 'package:first_app/quiz_app/util/app_metrics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({required this.choosenAnswers, super.key});

  final List<Map<String, String>> choosenAnswers;

  // List<Map<String, Object>> getSummaryData() {
  //   final List<Map<String, Object>> summary = [];

  //   for (var i = 0; i < choosenAnswers.length; i++) {
  //     summary.add({
  //       'question_index': i,
  //       'question': questions[i].questionText,
  //       'correct_answer': questions[i].answers[0],
  //       'user_answer': choosenAnswers[i],
  //     });
  //   }

  //   return summary;
  // }

  @override
  State<ResultScreen> createState() {
    return _ResultScreenState();
  }
}

class _ResultScreenState extends State<ResultScreen> {
  var count = 0;

  void onSelectAnswer() {
    if (count < questions.length - 1) {
      setState(() {
        count++;
      });
    } else {
      setState(() {
        count = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final QuizQuestion currentQuestion = questions[count];
    // // bất kỳ chỗ nào cần
    // final top = AppMetrics.instance.totalTopHeight;
    // // hoặc chỉ toolbar:
    // final toolbar = AppMetrics.instance.appBarHeight;

    int correctAnswers = 0;
    for (var i = 0; i < widget.choosenAnswers.length; i++) {
      if (widget.choosenAnswers[i]['correct_answer'] ==
          widget.choosenAnswers[i]['user_answer']) {
        setState(() {
          correctAnswers++;
        });
      }
    }
    return Expanded(
      // child: SizedBox(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            // width: double.maxFinite,
            // widthFactor: 0.5,
            child: Text(
              'Result !!!',
              textAlign: TextAlign.center,
              style: GoogleFonts.montez(
                fontSize: 34,
                fontStyle: FontStyle.italic,
                color: const Color.fromARGB(251, 255, 255, 255),
              ),
            ),
          ),
          Center(
            child: Text(
              'You answered $correctAnswers out of ${widget.choosenAnswers.length} questions correctly!',
              textAlign: TextAlign.center,
              style: GoogleFonts.italianno(
                fontSize: 38,
                color: const Color.fromARGB(250, 49, 165, 55),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            // height: ,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: widget.choosenAnswers.map((data) {
                  final isCorrect =
                      data['correct_answer'] == data['user_answer'];
                  return Row(
                    spacing: 100,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? const Color.fromARGB(255, 166, 208, 243)
                              : const Color.fromARGB(255, 128, 69, 124),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          data['question_index'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: isCorrect ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['question'] ?? '',
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Your answer: ${data['user_answer'] ?? ''} \nCorrect answer: ${data['correct_answer'] ?? ''}',
                              style: TextStyle(
                                fontSize: 14,
                                color: isCorrect ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),

          SizedBox(height: 70),
        ],
      ),
      // ),
    );
  }
}

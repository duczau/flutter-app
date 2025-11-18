import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() {
    return _QuestionScreenState();
  }
}

class _QuestionScreenState extends State<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Question 1", style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: const Color.fromARGB(251, 255, 255, 255),
          ),),
          
          SizedBox(height: 20),
          ElevatedButton(onPressed: () {}, child: Text("data")),
        ],
      ),
    );
  }
}

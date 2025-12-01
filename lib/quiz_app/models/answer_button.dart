import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton(this.answerText, this.onTap, {super.key});

  final String answerText;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(left: 100, right: 100),
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              // maximumSize: const Size(50, double.infinity),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: const Color.fromARGB(216, 175, 25, 150),
              foregroundColor: Colors.white,
            ),
            child: Text(
              answerText,
              textAlign: TextAlign.center,
              style: GoogleFonts.glory(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

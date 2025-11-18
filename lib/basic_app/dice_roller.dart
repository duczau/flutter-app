import 'dart:math';
import 'package:flutter/material.dart';

final random = Random();

class DiceRoller extends StatefulWidget {
  final String text;
  final List<Image> diceImages;
  final void Function(Image) onDiceRolled;
  const DiceRoller({
    required this.text,
    required this.diceImages,
    required this.onDiceRolled,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _DiceRollerState();
  }
}

class _DiceRollerState extends State<DiceRoller> {
  int diceRoll = 1;

  void rollDice() {
    setState(() {
      int diceIndex = random.nextInt(widget.diceImages.length);
      widget.onDiceRolled(widget.diceImages[diceIndex]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            enableFeedback: true,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            backgroundColor: const Color.fromARGB(
              255,
              255,
              255,
              255,
            ).withValues(alpha: 125, red: 0, green: 100, blue: 100),
          ),
          onPressed: rollDice,
          child: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 163, 29, 29),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:first_app/meals_app/models/meal.dart';
import 'package:flutter/material.dart';

class MealItemTrait extends StatelessWidget {
  const MealItemTrait({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        SizedBox(width: 3),
        Text(text, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
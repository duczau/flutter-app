import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 153, 104, 104),
            const Color.fromARGB(199, 48, 150, 119),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Text('Expenses Tracker Home Page'),
      ),
    );
  }
}
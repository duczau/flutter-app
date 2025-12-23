import 'package:first_app/expense_app/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget{
  const ExpenseItem({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Text(expense.title),
            const SizedBox(height: 4,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}'),
                Spacer(),
                Text(expense.formattedDate),
                Spacer(),
                Icon(expense.category.icon,),
                Text(expense.category.name),
              ],
            ),
            const SizedBox(height: 4,),
          ],
        ),
      ),
    );
  }
}
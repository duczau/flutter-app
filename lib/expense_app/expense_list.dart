import 'package:first_app/expense_app/expense_item.dart';
import 'package:first_app/expense_app/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseList(this.expenses, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.findRenderObject().toString()),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: ExpenseItem(expense: expenses[index]),
        );
      },
    );
  }
}

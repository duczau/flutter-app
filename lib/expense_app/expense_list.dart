import 'dart:math';

import 'package:first_app/expense_app/expense_item.dart';
import 'package:first_app/expense_app/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(Expense removeExpense) onRemoveExpense;

  const ExpenseList(this.expenses, this.onRemoveExpense, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return
        // GestureDetector(
        //   onTap: () {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(
        //         content: Text(context.findRenderObject().toString()),
        //         duration: Duration(seconds: 1),
        //       ),
        //     );
        //   },
        //   child: ExpenseItem(expense: expenses[index]),
        // );
        Dismissible(
          key: ValueKey(expense.id),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              return true;
            } else {
              final result = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Delete Expense ${expense.title}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('No'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Yes'),
                    ),
                  ],
                ),
              );
              return result;
            }
          },
          onDismissed: (direction) {
            onRemoveExpense(expense);
            // } else {
            //   showDialog(
            //     context: context,
            //     builder: (ctx) => CupertinoAlertDialog(
            //       title: Text("Delete Expense"),
            //       content: Text(
            //         "Do you want to delete ${expenses[index].title}?",
            //       ),
            //       actions: [
            //         TextButton(
            //           onPressed: () => Navigator.pop(ctx),
            //           child: Text('Ok'),
            //         ),
            //       ],
            //     ),
            //   );
            // }
          },
          child: ExpenseItem(expense: expense),
        );
      },
    );
  }
}

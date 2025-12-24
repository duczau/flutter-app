import 'package:first_app/expense_app/expense_list.dart';
import 'package:first_app/expense_app/models/expense.dart';
import 'package:first_app/expense_app/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      category: ExpenseCategory.work,
    ),
    Expense(title: 'Cinema', amount: 15.69, category: ExpenseCategory.leisure),
    Expense(
      title: 'Food Delivery',
      amount: 150.23,
      category: ExpenseCategory.food,
    ),
    Expense(
      title: 'Electricity Bill',
      amount: 75.00,
      category: ExpenseCategory.other,
    ),
    Expense(title: 'Travel', amount: 89.99, category: ExpenseCategory.travel),
  ];

  void _onAddExpense(Expense newExpense) {
    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  void _onRemoveExpense(Expense removeExpense) {
    final expenseIndex = _registeredExpenses.indexOf(removeExpense);
    setState(() {
      _registeredExpenses.remove(removeExpense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted ${removeExpense.title}'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, removeExpense);
            });
          },
        ),
      ),
    );
  }

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
      // child:
      //  SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (ctx) => NewExpense(onAddExpense: _onAddExpense),
              );
            },
            icon: const Icon(Icons.add_box_rounded),
            color: Colors.deepPurpleAccent,
            iconSize: 35,
          ),
          const SizedBox(height: 8),
          Expanded(child: ExpenseList(_registeredExpenses, _onRemoveExpense)),
        ],
      ),
      // ),
    );
  }
}

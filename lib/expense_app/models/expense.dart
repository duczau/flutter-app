import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

enum ExpenseCategory {
  food(Icons.fastfood, 'Food'),
  travel(Icons.flight, 'Travel'),
  leisure(Icons.free_breakfast_rounded, 'Leisure'),
  work(Icons.work, 'Work'),
  other(Icons.category, 'Other');

  final IconData icon;
  final String name;
  
  const ExpenseCategory([this.icon = Icons.category, this.name = '']);
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;

  Expense({
    required this.title,
    required this.amount,
    required this.category,
  }) : date = DateTime.now(),
       id = uuid.v7(), 
       assert(title.isNotEmpty, 'Title cannot be empty'),
       assert(amount > 0, 'Amount must be greater than zero');

  Expense.addDate({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  }) : id = uuid.v7(), 
       assert(title.isNotEmpty, 'Title cannot be empty'),
       assert(amount > 0, 'Amount must be greater than zero');

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final ExpenseCategory category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount; // sum = sum + expense.amount
    }

    return sum;
  }
}
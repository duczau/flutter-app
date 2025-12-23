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

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }
}
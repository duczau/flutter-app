import 'package:first_app/expense_app/chart/chart_bar.dart';
import 'package:first_app/expense_app/models/expense.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;

  List<ExpenseBucket> get buckets {
    for (var element in ExpenseCategory.values) {
      print(element);
    }
    return [
      ExpenseBucket.forCategory(expenses, ExpenseCategory.food),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.leisure),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.travel),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.work),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.other),
    ];
  }

  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }

    return maxTotalExpense;
  }

  List<ChartBar> chartBars(double maxExpense) {
    final List<ChartBar> chartBars = [];

    for (final bucket in buckets) {
      chartBars.add(
        ChartBar(
          fill: bucket.totalExpenses == 0
              ? 0
              : bucket.totalExpenses / maxExpense,
        ),
      );
    }

    return chartBars;
  }

  @override
  Widget build(BuildContext context) {
    final maxTotal = maxTotalExpense;

    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ...chartBars(maxTotal)
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        bucket.category.icon,
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
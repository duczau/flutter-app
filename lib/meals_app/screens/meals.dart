import 'package:first_app/meals_app/models/meal.dart';
import 'package:first_app/meals_app/widgets/meal_item.dart';
import 'package:flutter/material.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    required this.title,
    required this.meals,
    required this.toggleFavorite,
  });

  final String title;
  final List<Meal> meals;
  final void Function(Meal meal) toggleFavorite;

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemBuilder: (context, index) {
        return MealItem(
          meal: meals[index],
          toggleFavorite: toggleFavorite,
        );
      },
      itemCount: meals.length,
    );

    if (meals.isEmpty) {
      content = Center(
        child: Column(
          children: [
            Text('Uh oh ... No meals found!'),
            SizedBox(height: 16),
            Text(
              'Try selecting a different category!',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: content),
    );
  }
}

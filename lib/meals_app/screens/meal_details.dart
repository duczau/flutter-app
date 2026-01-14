import 'package:first_app/meals_app/models/meal.dart';
import 'package:flutter/material.dart';

class MealDetailScreen extends StatelessWidget {
  const MealDetailScreen({super.key, required this.meal, required this.toggleFavorite});

  final Meal meal;
  final void Function(Meal meal) toggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 28.0),
            child: IconButton(
              onPressed: () {
                toggleFavorite(meal);
              },
              icon: Icon(Icons.favorite),
              isSelected: false,
              selectedIcon: Icon(Icons.fax_sharp),
              color: Colors.red,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      body: ListView(
        children: [
          Image.network(meal.imageUrl, fit: BoxFit.cover),
          Text(
            'Ingredients',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: Colors.orange),
          ),
          for (var ingredient in meal.ingredients)
            Text(
              ingredient,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          SizedBox(height: 16),
          Text(
            'Steps',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: Colors.orange),
          ),
          for (var step in meal.steps)
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                step,
                textAlign: TextAlign.start,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.lightGreen),
              ),
            ),
        ],
      ),
    );
  }
}

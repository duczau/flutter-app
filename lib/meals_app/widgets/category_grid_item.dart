import 'package:first_app/meals_app/data/dummy_data.dart';
import 'package:first_app/meals_app/models/category.dart';
import 'package:first_app/meals_app/models/meal.dart';
import 'package:first_app/meals_app/screens/meals.dart';
import 'package:flutter/material.dart';

class CategoryGridItem extends StatelessWidget {
  final Category category;
  final void Function(Meal meal) toggleFavorite;
  final List<Meal> availableMeals;

  const CategoryGridItem({
    super.key,
    required this.category,
    required this.toggleFavorite,
    required this.availableMeals,
  });

  @override
  Widget build(BuildContext context) {
    var categoryLength = availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList()
        .length;
    return InkWell(
      splashColor: Colors.lightGreen,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealsScreen(
              title: category.title,
              meals: availableMeals
                  .where((meal) => meal.categories.contains(category.id))
                  .toList(),
              toggleFavorite: toggleFavorite,
            ),
            settings: RouteSettings(name: '/${category.id}'),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [category.color.withOpacity(0.5), category.color],
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            "${category.title} - ${categoryLength} meals",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

import 'package:first_app/meals_app/models/meal.dart';
import 'package:first_app/meals_app/screens/meal_details.dart';
import 'package:first_app/meals_app/widgets/meal_item_trait.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  const MealItem({
    super.key,
    required this.meal,
    required this.toggleFavorite,
  });

  final Meal meal;
  final void Function(Meal meal) toggleFavorite;

  String get complexityText {
    return meal.complexity.name[0].toUpperCase() +
        meal.complexity.name.substring(1);
  }

  String get affordabilityText {
    return meal.affordability.name[0].toUpperCase() +
        meal.affordability.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealDetailScreen(meal: meal, toggleFavorite: toggleFavorite),
            ),
          );
        },
        child: Stack(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(meal.imageUrl),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                color: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MealItemTrait(
                          icon: Icons.access_time,
                          text: '${meal.duration.toString()} min',
                        ),
                        MealItemTrait(icon: Icons.work, text: complexityText),
                        MealItemTrait(
                          icon: Icons.attach_money,
                          text: affordabilityText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

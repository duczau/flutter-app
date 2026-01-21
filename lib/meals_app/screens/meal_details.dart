import 'package:first_app/meals_app/models/meal.dart';
import 'package:first_app/meals_app/provider/meals_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealDetailScreen extends ConsumerWidget {
  const MealDetailScreen({
    super.key,
    required this.meal,
    required this.toggleFavorite,
  });

  final Meal meal;
  final void Function(Meal meal) toggleFavorite; // change to provider

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final isFavorite = ref.read(favouriteMealsProvider).contains(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 28.0),
            child: IconButton(
              onPressed: () {
                // toggleFavorite(meal);
                ref.read(counterProvider.notifier).state++;

                final isNowFavorite = ref
                    .read(favouriteMealsProvider.notifier)
                    .toggleAddMealFavouriteStatus(meal);
                if (isNowFavorite) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Added to favorites!"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Removed from favorites!"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              // implicit animation
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) =>
                    RotationTransition(turns: animation, child: child),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.star,
                  key: ValueKey(isFavorite),
                ),
              ),
              // isSelected: isFavorite,
              // selectedIcon: Icon(Icons.favorite, color: Colors.red), // không hoạt động với AnimatedSwitcher
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      body: ListView(
        children: [
          Hero(
            tag: meal.id,
            child: Image.network(meal.imageUrl, fit: BoxFit.contain),
          ),
          Text(
            'Ingredients - $count',
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

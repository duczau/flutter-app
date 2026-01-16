import 'package:first_app/meals_app/data/dummy_data.dart';
import 'package:first_app/meals_app/models/meal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final mealsProvider = Provider((ref) {
  //A provider that exposes a read-only value.
  return dummyMeals;
});

class MealsNotifier extends StateNotifier<List<Meal>> {
  MealsNotifier() : super([]);

  void toggleMealFavouriteStatus(Meal meal) {
    final isFavourite = state.contains(meal);

    // phai tao list moi de data phat hien thay doi object address, khong duoc dung add() hay remove()
    if (isFavourite) {
      state = state.where((m) => m.id != meal.id).toList();
    } else {
      state = [...state, meal];
    }
  }
}

final favouriteMealsProvider = StateNotifierProvider<MealsNotifier, List<Meal>>(
  (ref) {
    return MealsNotifier();
  },
);

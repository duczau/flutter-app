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

  bool toggleAddMealFavouriteStatus(Meal meal) {
    final isFavourite = state.contains(meal);

    // phai tao list moi de data phat hien thay doi object address, khong duoc dung add() hay remove()
    if (isFavourite) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favouriteMealsProvider = StateNotifierProvider<MealsNotifier, List<Meal>>(
  (ref) {
    return MealsNotifier();
  },
);

final counterProvider = StateProvider<int>((ref) {
  return 0; // Initial value
});

class FilteredMealsNotifier extends Notifier<Map<String, bool>> {
  Map<String, bool> initialFilters = {
    "Gluten": false,
    "Vegan": false,
    "Vegetarian": false,
    "Lactose": false,
  };

  @override
  Map<String, bool> build() {
    return initialFilters;
  }

  void setFilters(Map<String, bool> filterData) {
    state = {...state, ...filterData};
  }
}

final filteredMealsProvider =
    NotifierProvider<FilteredMealsNotifier, Map<String, bool>>(() {
      return FilteredMealsNotifier();
    });

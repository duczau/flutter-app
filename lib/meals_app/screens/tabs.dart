import 'package:first_app/meals_app/data/dummy_data.dart';
import 'package:first_app/meals_app/models/meal.dart';
import 'package:first_app/meals_app/provider/meals_provider.dart';
import 'package:first_app/meals_app/screens/categories.dart';
import 'package:first_app/meals_app/screens/meals.dart';
import 'package:first_app/meals_app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabScreen extends ConsumerStatefulWidget {
  const TabScreen({super.key});

  @override
  ConsumerState<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends ConsumerState<TabScreen> {
  int _selectedTabIndex = 0;
  List<Meal> favoriteMeals = [];
  List<Meal> availableMeals = [];
  String activeTabTitle = '';
  late Widget activeScreen;

  Map<String, bool> mapFilter = {
    "Gluten": false,
    "Vegan": false,
    "Vegetarian": false,
    "Lactose": false,
  };

  @override
  void initState() {
    super.initState();
    availableMeals = dummyMeals;
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 3)),
    );
  }

  void _toggleFavoriteMeal(Meal meal) {
    final isExisting = favoriteMeals.contains(meal);
    if (isExisting) {
      setState(() {
        favoriteMeals.remove(meal);
      });
      _showInfoMessage("remove meal");
    } else {
      setState(() {
        favoriteMeals.add(meal);
      });
      _showInfoMessage("add meal");
    }
  }

  void _selectTab(int value) {
    setState(() {
      _selectedTabIndex = value;
    });
  }

  void _onFilterChanged(Map<String, bool> updatedFilter) {
    setState(() {
      mapFilter = updatedFilter;
      _filterMeals();
    });
    print('Filter updated: $mapFilter');
  }

  // ✅ Hàm lọc meals theo filter
  void _filterMeals() {
    // Ví dụ: nếu Gluten = true, chỉ show meals không có gluten
    final filtered = dummyMeals.where((meal) {
      if (mapFilter["Gluten"] == true && !meal.isGlutenFree) {
        return false;
      }
      if (mapFilter["Vegan"] == true && !meal.isVegan) {
        return false;
      }
      if (mapFilter["Vegetarian"] == true && !meal.isVegetarian) {
        return false;
      }
      if (mapFilter["Lactose"] == true && !meal.isLactoseFree) {
        return false;
      }
      return true;
    }).toList();
    favoriteMeals = filtered;
    availableMeals = filtered;
  }

  @override
  Widget build(BuildContext context) {
    final mea = ref.watch(mealsProvider);
    if (_selectedTabIndex == 0) {
      activeTabTitle = 'Pick your category';
      activeScreen = CategoriesScreen(availableMeals: availableMeals, toggleFavorite: _toggleFavoriteMeal);
    } else {
      activeTabTitle = 'Your Favorites';
      activeScreen = MealsScreen(
        title: 'zzzz',
        meals: favoriteMeals,
        toggleFavorite: _toggleFavoriteMeal,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(activeTabTitle)),
      drawer: MainDrawer(
        selectTab: _selectTab,
        mapFilter: mapFilter,
        onFilterChanged: _onFilterChanged,
      ),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectTab,
        currentIndex: _selectedTabIndex,
        mouseCursor: MouseCursor.defer,
        selectedItemColor: Colors.blue,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

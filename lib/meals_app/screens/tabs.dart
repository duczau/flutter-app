import 'package:first_app/meals_app/models/meal.dart';
import 'package:first_app/meals_app/screens/categories.dart';
import 'package:first_app/meals_app/screens/meals.dart';
import 'package:first_app/meals_app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedTabIndex = 0;
  List<Meal> favoriteMeals = [];
  String activeTabTitle = '';
  late Widget activeScreen;

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
        if (value == 0) {
          activeTabTitle = 'Pick your category';
          activeScreen = CategoriesScreen(toggleFavorite: _toggleFavoriteMeal);
        } else {
          activeTabTitle = 'Your Favorites';
          activeScreen = MealsScreen(
            title: 'zzzz',
            meals: favoriteMeals,
            toggleFavorite: _toggleFavoriteMeal,
          );
        }
      });
    }

  @override
  void initState() {
    super.initState();
    activeScreen = CategoriesScreen(toggleFavorite: _toggleFavoriteMeal);
  }

  @override
  Widget build(BuildContext context) {
    // if (_selectedTabIndex == 1) {
    //   activeScreen = MealsScreen(title: 'Your Favorites', meals: favoriteMeals);
    //   activeTabTitle = 'Your Favorites';
    // }

    return Scaffold(
      appBar: AppBar(title: Text(activeTabTitle)),
      drawer: MainDrawer(selectTab: _selectTab,),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectTab,
        currentIndex: _selectedTabIndex,
        mouseCursor: MouseCursor.defer,
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

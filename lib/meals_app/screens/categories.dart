import 'package:first_app/meals_app/data/dummy_data.dart';
import 'package:first_app/meals_app/models/category.dart';
import 'package:first_app/meals_app/models/meal.dart';
import 'package:first_app/meals_app/widgets/category_grid_item.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.toggleFavorite,
    required this.availableMeals,
  });
  final List<Meal> availableMeals;
  final void Function(Meal meal) toggleFavorite; // change to provider
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  // explicit animation controller
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      upperBound: 1,
      lowerBound: 0,
      value: 0.1,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sizeText = MediaQuery.of(context).size.width * 0.03;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        ),
        child: child,
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          // childAspectRatio: 3 / 2, // giới hạn tỉ lệ chiều rộng/chiều cao, khiến cho item không thể giãn tự do
          mainAxisSpacing: 10,
          crossAxisSpacing: 15,
        ),
        cacheExtent: 10,
        itemCount: availableCategories.length,
        itemBuilder: (context, index) {
          return
          // SlideTransition(
          //   position: _animationController.drive(
          //     Tween(
          //       begin: Offset((Random().nextDouble() * pow(-1, index) - 1), pow(-1, index).roundToDouble()),
          //       end: Offset.zero,
          //     ),
          //   ),
          //   child:
          Column(
            children: [
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Theme(
                    // thay đổi màu cho từng widget con bên trong, không ảnh huởng đến bên ngoài
                    data: Theme.of(context).copyWith(
                      textTheme: Theme.of(context).textTheme.copyWith(
                        // thay copyWith bằng apply chỉ áp dụng khi chưa set ở main.dart
                        titleSmall: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(color: Colors.lime),
                      ),
                    ),
                    child: Builder(
                      builder: (BuildContext newContext) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "data-",
                                  style: TextStyle(
                                    fontSize: sizeText,
                                    color: Theme.of(
                                      newContext,
                                    ).textTheme.titleSmall?.color,
                                  ),
                                ),
                                Text(
                                  'Category $index',
                                  style:
                                      TextStyle(
                                        fontSize: sizeText,
                                        color: Theme.of(
                                          newContext,
                                        ).textTheme.titleSmall?.color,
                                      ).merge(
                                        // kết hợp và ghi  đè những thuộc tính đã có
                                        TextStyle(color: Colors.white),
                                      ), // copywith tao 1 ban sao cho titleSmall o main.dart
                                ),
                              ],
                            ), // nếu không chỉ định titleSmall, sẽ ăn theo mặc định là bodyMedium
                            DefaultTextStyle(
                              // style riêng cho 1 widget con
                              style: const TextStyle(color: Colors.deepPurple),
                              child: Text('Only this text'),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CategoryGridItem(
                  availableMeals: widget.availableMeals,
                  category: availableCategories[index],
                  toggleFavorite: widget.toggleFavorite,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

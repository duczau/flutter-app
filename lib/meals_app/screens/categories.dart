import 'package:first_app/meals_app/data/dummy_data.dart';
import 'package:first_app/meals_app/models/category.dart';
import 'package:first_app/meals_app/models/meal.dart';
import 'package:first_app/meals_app/widgets/category_grid_item.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.toggleFavorite});
  final void Function(Meal meal) toggleFavorite;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 15,
      ),
      cacheExtent: 10,
      itemCount: availableCategories.length,
      itemBuilder: (context, index) {
        return Column(
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
                                "data - ",
                                style: Theme.of(
                                  newContext,
                                ).textTheme.titleSmall,
                              ),
                              Text(
                                'Category $index',
                                style: Theme.of(newContext)
                                    .textTheme
                                    .titleSmall!
                                    .merge(
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
              child: CategoryGridItem(category: availableCategories[index], toggleFavorite: toggleFavorite),
            ),
          ],
        );
      },
    );
  }
}

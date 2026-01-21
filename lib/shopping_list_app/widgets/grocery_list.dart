import 'package:first_app/shopping_list_app/data/dummy_data.dart';
import 'package:flutter/material.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) {
          final item = groceryItems[index];
          return ListTile(
            title: Text(item.name),
            leading: CircleAvatar(
              backgroundColor: item.category.color,
              child: Text(
                item.category.title[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
              onPressed: () {
                // Handle delete action
              },
            ),
            subtitle: Text('${item.quantity}x ${item.category.title}'),
          );
        },
      ),
    );
  }
}
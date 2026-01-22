import 'package:first_app/shopping_list_app/data/dummy_data.dart';
import 'package:first_app/shopping_list_app/models/category.dart';
import 'package:first_app/shopping_list_app/models/grocery_item.dart';
import 'package:first_app/shopping_list_app/widgets/new_item.dart';
import 'package:flutter/material.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  void _addNewItem() async {
    final newItem = await Navigator.of(context).push<Map<String, Object?>>(
      MaterialPageRoute(builder: (ctx) => const NewItem()),
    );
    if (newItem != null) {
      setState(() {
        groceryItems.add(
          GroceryItem(
            id: DateTime.now().toString(),
            name: newItem['name'] as String,
            quantity: newItem['quantity'] as int,
            category: newItem['category'] as Category,
          ),
        );
      });
      print(groceryItems.last);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _addNewItem();
            },
          ),
          const SizedBox(width: 30),
        ],
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) {
          final item = groceryItems[index];
          return Dismissible(
            secondaryBackground: Container(
              color: const Color.fromARGB(255, 238, 52, 19),
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.delete_forever_rounded,
                    size: 20,
                  ),
                  Text('No confirm'),
                ],
              ),
            ),
            background: Container(
              color: const Color.fromARGB(255, 169, 201, 111),
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning,
                    size: 20,
                  ),
                  Text('Confirm'),
                ],
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                groceryItems.removeAt(index);
              });
            },
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                return true;
              } else {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Delete Item ${item.name}?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
                return result;
              }
            },
            key: ValueKey(item.id),
            child: ListTile(
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
                  setState(() {
                    groceryItems.removeAt(index);
                  });
                },
              ),
              subtitle: Text('${item.quantity}x ${item.category.title}'),
            ),
          );
        },
      ),
    );
  }
}

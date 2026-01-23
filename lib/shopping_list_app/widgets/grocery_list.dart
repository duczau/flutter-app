import 'dart:convert';

import 'package:first_app/shopping_list_app/data/dummy_data.dart';
import 'package:first_app/shopping_list_app/models/category.dart';
import 'package:first_app/shopping_list_app/models/grocery_item.dart';
import 'package:first_app/shopping_list_app/widgets/new_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final urlRoot = dotenv.env['FIREBASE_RTDB_URL'] ?? "";
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  var _loadingText = '';

  void _addNewItem() async {
    final newItem = await Navigator.of(context).push<Map<String, Object?>>(
      MaterialPageRoute(builder: (ctx) => const NewItem()),
    );
    if (newItem != null) {
      final cate = newItem['category'] as Map<String, Object?>;
      setState(() {
        _groceryItems.add(
          GroceryItem(
            id: newItem['id'] as String,
            name: newItem['name'] as String,
            quantity: newItem['quantity'] as int,
            category: Category(
              cate['title'] as String,
              Color(cate['color'] as int),
            ),
          ),
        );
      });
    }
  }

  Future<void> _loadItems() async {
    //fetch from database
    await Future.delayed(const Duration(milliseconds: 500));
    final url = Uri.https(urlRoot, 'shopping-list.json');
    final getList = await http.get(url);
    final List<GroceryItem> loadedItems = [];
    if (getList.body == 'null') {
      setState(() {
        _groceryItems = [];
        _isLoading = false;
      });
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text('No items found in the database.'),
        ),
      );

      return;
    }
    final extractedData = json.decode(getList.body) as Map<String, dynamic>;
    for (final item in extractedData.entries) {
      final cate = item.value['category'] as Map<String, dynamic>;
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: Category(
            cate['title'] as String,
            Color(cate['color'] as int),
          ),
        ),
      );
    }
    setState(() {
      _groceryItems = loadedItems;
      _isLoading = false;
    });
  }

  Future<void> removeItem(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final deleteUrl = Uri.https(urlRoot, 'shopping-list/$id.json');
    final response;
    try {
      response = await http.delete(deleteUrl);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Failed to delete item.'),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      print(e);
      throw Exception('Failed to delete item.');
    }
    if (response.statusCode >= 400) {
      setState(() {
        _isLoading = false;
      });
      await Future.delayed(const Duration(seconds: 1));

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Failed to delete item.'),
        ),
      );
      // // ignore: use_build_context_synchronously
      // throw Exception('Failed to delete item.');
    }
  }

  Future<void> _handleRemove(String id) async {
    setState(() {
      _isLoading = true;
      _loadingText = 'Deleting item...';
    });
    await removeItem(id);

    setState(() {
      _loadingText = 'Loading your grocery items...';
    });
    await _loadItems();

    // setState(() {
    //   _groceryItems.removeAt(index);
    // });
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
    _loadingText = 'Loading your grocery items...';
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingContent = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator.adaptive(),
          SizedBox(height: 16),
          Text(_loadingText, style: TextStyle(fontSize: 24)),
        ],
      ),
    );

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
      body: _isLoading
          ? loadingContent
          : RefreshIndicator(
              onRefresh: _loadItems,
              child: _groceryItems.isEmpty
                  ? Center(child: Text('No items found.'))
                  : ListView.builder(
                      itemCount: _groceryItems.length,
                      itemBuilder: (ctx, index) {
                        final item = _groceryItems[index];
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
                                const Icon(Icons.warning, size: 20),
                                Text('Confirm'),
                              ],
                            ),
                          ),
                          onDismissed: (direction) async {
                            await _handleRemove(item.id);
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
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
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
                              onPressed: () async {
                                await _handleRemove(item.id);
                              },
                            ),
                            subtitle: Text(
                              '${item.quantity}x ${item.category.title}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}

import 'dart:convert';

import 'package:first_app/shopping_list_app/data/categories.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, Object?> _formData = {
    'name': null,
    'quantity': null,
    'category': null,
  };
  void _addNewItem() async {
    if (_formKey.currentState!.validate()) {
      // send to database
      final url = Uri.https('flutter-demo-duczau-default-rtdb.asia-southeast1.firebasedatabase.app', '');
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({..._formData, 'category': (_formData['category'] as dynamic)?.title}),
      );

      final getList = await http.get(url);
      print('Get data from database: ${getList.body}');
      
      _formKey.currentState!.save();
      Navigator.of(context).pop(_formData);
      print(_formData);
    }
    //  else {
    //   _formKey.currentState!.reset();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       duration: Duration(seconds: 1),
    //       content: Text('Form has been reset'),
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Item')),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) {
              return; // Đã pop rồi, không làm gì
            }

            final shouldExit = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Exit adding new item?'),
                content: Text('Your progress will be lost'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text('Continue editing'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text('Exit'),
                  ),
                ],
              ),
            );

            if (shouldExit == true && context.mounted) {
              Navigator.pop(context);
            }
          },
          // autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            children: <Widget>[
              TextFormField(
                // instead of TextField to use inside Form
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length == 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (newValue) => _formData['name'] = newValue?.trim(),  // khong can wrap setState vi khong can rebuild UI, only save data
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return 'Quantity must be a positive number.';
                        }
                        return null;
                      },
                      onChanged: (newValue) {
                        _formData['quantity'] = int.tryParse(newValue);
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: DropdownButtonFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a category.';
                        }
                        return null;
                      },
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.rectangle, // Or Icons.diamond_outlined
                                  size: 15.0,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 8.0),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: null,
                            child: Row(
                              children: [
                                Text('None'),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        print(value?.toJson().toString());
                        _formData['category'] = value;
                      },
                    ),
                  ), // Add category selection
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addNewItem();

                      final context = _formKey.currentContext;
                      if (context != null) {
                        // Lấy size
                        final RenderBox box =
                            context.findRenderObject() as RenderBox;
                        final size = box.size;
                        print('Size: $size');

                        // Lấy position
                        final position = box.localToGlobal(Offset.zero);
                        print('Position: $position');

                        // Show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text(_formData.toString()),
                          ),
                        );
                      }
                    },
                    child: const Text('Add Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:first_app/favourite_places_app/provider/place_provider.dart';
import 'package:first_app/favourite_places_app/widgets/input_image.dart';
import 'package:first_app/favourite_places_app/widgets/input_location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlace extends ConsumerStatefulWidget {
  const AddPlace({super.key});

  @override
  ConsumerState<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlace> {
  final _titleController = TextEditingController();
  Object? filePath;

  void _addPlace() {
    final textIn = _titleController.text;
    if (textIn.trim().isEmpty) {
      return;
    }
    ref.read(userPlaceProvider.notifier).addPlace(textIn, filePath??"");
  }

  void _onAddImage(Object path) {
    filePath = path;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a New Place')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
            ),
            InputImage(onAddImage: _onAddImage),
            const SizedBox(height: 16),
            InputLocation(),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _addPlace();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.add_box_rounded, color: Colors.red),
              label: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:first_app/favourite_places_app/provider/place_provider.dart';
import 'package:first_app/favourite_places_app/screens/add_place.dart';
import 'package:first_app/favourite_places_app/widgets/place_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceScreen extends ConsumerWidget {
  const PlaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listPlace = ref.watch(userPlaceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        toolbarHeight: 40,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 32),
            child: IconButton(
              icon: Icon(Icons.add_circle, color: Colors.pink[300],),
              onPressed: () {
                // Navigate to the add place screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddPlace(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: PlaceList(places: listPlace),
      ),
    );
  }
}
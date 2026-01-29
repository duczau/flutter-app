import 'dart:io';

import 'package:first_app/favourite_places_app/models/place.dart';
import 'package:first_app/favourite_places_app/provider/place_provider.dart';
import 'package:first_app/favourite_places_app/screens/place_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceList extends ConsumerWidget {
  const PlaceList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (places.isEmpty) {
      return const Center(child: Text('No places added yet.'));
    }

    Widget _getImage(Place place) {
      if (place.imagePath != null && place.imagePath.toString().isNotEmpty) {
        if (kIsWeb) {
          return Image.memory(place.imagePath as Uint8List);
        } else {
          return Image.file(
            place.imagePath as File,
            width: double.infinity,
          );
        }
      }
      return Icon(Icons.emoji_emotions,color: const Color.fromARGB(179, 173, 58, 177),);
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        return ListTile(
          key: ValueKey(places[index].id),
          title: Text(places[index].title),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(20.0), //or 15.0
            child: _getImage(places[index]),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            color: Theme.of(context).colorScheme.error,
            onPressed: () async {
              ref.read(userPlaceProvider.notifier).removePlace(places[index]);
            },
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceDetail(place: places[index]),
            ),
          ),
        );
      },
    );
  }
}

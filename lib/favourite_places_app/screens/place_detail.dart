import 'dart:io';

import 'package:first_app/favourite_places_app/models/place.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlaceDetail extends StatelessWidget {
  const PlaceDetail({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    Widget _image = SizedBox();
    if (place.imagePath != null && place.imagePath.toString().isNotEmpty) {
      if (kIsWeb) {
        _image = Image.memory(place.imagePath as Uint8List);
      } else {
        _image = Image.file(
          File(place.imagePath as String),
          width: double.infinity,
        );
      }
    }
    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: Column(children: [Text(place.title), _image]),
    );
  }
}

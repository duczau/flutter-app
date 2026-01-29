import 'dart:io';

import 'package:first_app/favourite_places_app/models/place.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class UserPlaceNotifier extends StateNotifier<List<Place>> {
  UserPlaceNotifier() : super(const []);

  void addPlace(String title, Object? filePath) async {
    final newPlace = Place(title: title, imagePath: filePath);
    state = [newPlace, ...state];
  }

  void addPlaceToDB(String title, File image) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');

    final newPlace = Place(title: title, imagePath: copiedImage);

    final dbPath = await sql.getDatabasesPath();

    // if places.db does not exist, create it
    final db = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE places (id TEXT PRIMARY KEY, title TEXT, imagePath TEXT)',
        );
      },
    );
    db.insert('places', newPlace.toMap());

    state = [newPlace, ...state];
  }

  void removePlace(Place place) {
    state = state.where((m) => m.id != place.id).toList();
  }
}

final userPlaceProvider = StateNotifierProvider<UserPlaceNotifier, List<Place>>(
  (ref) => UserPlaceNotifier(),
);

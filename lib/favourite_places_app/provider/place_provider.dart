import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:first_app/favourite_places_app/models/place.dart';
import 'package:first_app/favourite_places_app/storage/database_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class UserPlaceNotifier extends StateNotifier<List<Place>> {
  UserPlaceNotifier() : super(const []);

  void addPlace(String title, Object? filePath) async {
    final newPlace = Place.autoId(title: title, imagePath: filePath);
    state = [newPlace, ...state];
  }

  void removePlace(Place place) {
    state = state.where((m) => m.id != place.id).toList();
  }
}

final userPlaceProvider = StateNotifierProvider<UserPlaceNotifier, List<Place>>(
  (ref) => UserPlaceNotifier(),
);

class AsyncUserPlaceNotifier extends AsyncNotifier<List<Place>> {
  final db = DatabaseManager();

  @override
  FutureOr<List<Place>> build() {
    return db.places.getAll();
  }

  Future<void> addPlaceToDB(String title, Uint8List? image) async {
    state = AsyncLoading();
    final newPlace = Place.autoId(title: title, imagePath: image);
    await db.places.put(newPlace.id, newPlace);

    state = AsyncData(await db.places.getAll());
  }

  Future<void> removePlace(Place place) async {
    state = AsyncLoading();
    await db.places.deleteAtKey(place.id);
    state = AsyncData(await db.places.getAll());
  }

  Future<void> reload() async {
    await db.places.close();
    await db.places.init();
    state = AsyncLoading();
    state = AsyncData(await db.places.getAll());
  }
}

final asyncUserPlaceProvider =
    AsyncNotifierProvider<AsyncUserPlaceNotifier, List<Place>>(
      AsyncUserPlaceNotifier.new,
    );

import 'package:first_app/favourite_places_app/models/place.dart';
import 'package:first_app/favourite_places_app/storage/hive_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DatabaseManager {
  static final DatabaseManager _instance =
      DatabaseManager._internal(); // private constructor

  // like singleton
  factory DatabaseManager() {
    return _instance;
  }

  DatabaseManager._internal();

  // service for models
  late HiveService<Place> places;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }
    // Initialize Hive (works on all platforms)
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(PlaceAdapter());

    // Initialize services
    places = HiveService<Place>('places');

    // Initialize database
    await places.init();

    _initialized = true;
  }

  Future<void> close() async {
    await places.close();
    _initialized = false;
  }

  Future<void> clearAll() async {
    await places.clear();
  }

  Future<void> deleteFromDisk() async {
    await places.deleteFromDisk();
    _initialized = false;
  }
}

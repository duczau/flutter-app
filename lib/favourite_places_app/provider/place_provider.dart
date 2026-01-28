import 'package:first_app/favourite_places_app/models/place.dart';
import 'package:flutter_riverpod/legacy.dart';

class UserPlaceNotifier extends StateNotifier<List<Place>> {
  UserPlaceNotifier() : super(const []);

  void addPlace(String title, Object? filePath) {
    final newPlace = Place(title: title, imagePath: filePath);
    state = [newPlace, ...state];
  }

  void removePlace(Place place) {
    state = state.where((m) => m.id != place.id).toList();
  }
}

final userPlaceProvider = StateNotifierProvider<UserPlaceNotifier, List<Place>>(
  (ref) => UserPlaceNotifier(),
);

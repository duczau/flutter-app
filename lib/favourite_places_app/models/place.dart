import 'package:uuid/uuid.dart';

class Place {
  final String id;
  final String title;
  final Object? imagePath;
  final PlaceLocation? placeLocation;

  Place({
    required this.title,
    required this.imagePath,
    this.placeLocation,
  }) : id = Uuid().v4();

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
    };
  }
}

class PlaceLocation {
  final double latitude;
  final double longitude;

  PlaceLocation({required this.latitude, required this.longitude});
}

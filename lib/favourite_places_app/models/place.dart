import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'place.g.dart';

@HiveType(typeId: 0)
class Place extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final Object? imagePath;
  final PlaceLocation? placeLocation;

  Place.autoId({
    required this.title,
    required this.imagePath,
    this.placeLocation,
  }) : id = Uuid().v4();

  Place({required this.id, required this.title, required this.imagePath, this.placeLocation});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
    };
  }

  Place fromMap(Map map) {
    return Place(
      id: map['id'] as String,
      title: map['title'] as String,
      imagePath: map['imagePath'] as String,
    );
  }
}

class PlaceLocation {
  final double latitude;
  final double longitude;

  PlaceLocation({required this.latitude, required this.longitude});
}

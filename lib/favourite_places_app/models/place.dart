import 'package:uuid/uuid.dart';

class Place {
  final String id;
  final String title;
  final Object? imagePath;

  Place({
    required this.title,
    required this.imagePath
  }) : id = Uuid().v4();
}
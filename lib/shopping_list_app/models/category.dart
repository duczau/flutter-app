import 'package:flutter/material.dart';

class Category {
  const Category(this.title, this.color);

  final String title;
  final Color color;

  Map<String, String> toJson() => {
        'title': title,
        'color': color.toString(),
      };
}

enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  frozen,
  hygiene,
  other,
}
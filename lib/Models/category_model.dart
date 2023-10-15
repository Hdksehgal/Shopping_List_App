import 'package:flutter/material.dart';
enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}

class Category {
  const Category(this.grocery, this.indicate);

  final String grocery;
  final Color indicate;

}
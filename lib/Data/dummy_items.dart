import 'package:flutter/material.dart';
import 'package:shopping_list_app/Data/Categories.dart';
import 'package:shopping_list_app/Models/category_model.dart';
import 'package:shopping_list_app/Models/grocery_item.dart';

final groceryItems = [
  GroceryItem(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: categories[Categories.dairy]!),//AL : Categories.dairy
  GroceryItem(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: categories[Categories.fruit]!),// AL:Categories.fruit
  GroceryItem(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      category: categories[Categories.meat]!),//AL:Categories.meat
];
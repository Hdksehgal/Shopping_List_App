import 'package:shopping_list_app/Models/category_model.dart';

class GroceryItem {
  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category
  });

  final String id;
  final String name;
  final int quantity;
  final Category category; // AL:final Categories category
}
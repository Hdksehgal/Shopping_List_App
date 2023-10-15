import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list_app/Data/dummy_items.dart';
import 'package:shopping_list_app/Models/category_model.dart';
import 'package:shopping_list_app/Models/grocery_item.dart';
import 'package:shopping_list_app/Data/Categories.dart';
import 'package:shopping_list_app/Widgets/New_Item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({
    super.key,
    //required this.grocery
  });
  //final GroceryItem grocery;

  @override
  State<GroceryList> createState() {
    return _GroceryListState();
  }
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _additem() async {
    final newItem = await Navigator.of(context)
        .push<GroceryItem>(MaterialPageRoute(builder: (context) => NewItem()));

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: _additem,
            icon: Icon(Icons.add, size: 30),
          )
        ],
        //backgroundColor: ,
      ),
      body: _groceryItems.isEmpty
          ? const Center(
              child: Text(
              "You got no Items yet !",
              style: TextStyle(
              color:  Color.fromARGB(113, 249, 247, 252),
              fontSize: 30,
              //fontWeight: FontWeight.bold,

              ),
            ))
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (ctx, item) => Dismissible(
                key: ValueKey(_groceryItems[item].id),
                onDismissed: (direction){
                  setState(() {
                    _groceryItems.remove(_groceryItems[item]);
                  });
                },
                child: ListTile(
                      leading:
                          // Container(
                          //   width: 24,
                          //   height: 24,
                          //   color: groceryItems[item].category.indicate,
                          // ) ,
                          //AL: Alternate
                          Icon(
                        Icons.square_rounded,
                        color: _groceryItems[item].category.indicate,
                      ),
                      title: Text(_groceryItems[item].name),
                      style: ListTileStyle.drawer,
                      trailing: Text(_groceryItems[item].quantity.toString()),
                    ),
              )),
    );
  }
}

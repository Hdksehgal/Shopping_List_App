import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list_app/Data/dummy_items.dart';
import 'package:shopping_list_app/Models/category_model.dart';
import 'package:shopping_list_app/Models/grocery_item.dart';
import 'package:shopping_list_app/Data/Categories.dart';
import 'package:shopping_list_app/Widgets/New_Item.dart';
import 'package:http/http.dart' as https;

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
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  void _loadState() async {
    final url = Uri.https(
        "shopping-list-flutter-e2644-default-rtdb.firebaseio.com",
        "shopping-list.json");

    try{
      final response = await https.get(url);
      print(response.statusCode);

      if (response.statusCode >= 400) {
        setState(() {
          _error = "Error! Try again later";
        });
      }

      if(response.body == null)
      {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listdata = json.decode(response.body);
      final List<GroceryItem> loadeditems = [];

      for (final item in listdata.entries) {
        final category = categories.entries
            .firstWhere(
                (catitem) => catitem.value.grocery == item.value['category'])
            .value;

        loadeditems.add(GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category));
      }

      setState(() {
        _groceryItems = loadeditems;
        _isLoading = false;
      });

    }catch(err){
      setState(() {
        _error = "Something went wrong!        Try again later";
      });
    }

  }

  void _additem() async {
    final newItem = await Navigator.of(context)
        .push<GroceryItem>(MaterialPageRoute(builder: (context) => NewItem()));
    //_loadState();
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });

    // if we use the _loadstate function that method includes an extra
    // responses which affects the efficiency of the code that is why
    // in order to make the code more optimized we use this
  }

  void _removeitem(GroceryItem item) async {
    int index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https(
        'shopping-list-flutter-e2644-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    final responsedel = await https.delete(url);

    if (responsedel.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
        child: Text(
      "You got no Items yet !",
      style: TextStyle(
        color: Color.fromARGB(113, 249, 247, 252),
        fontSize: 30,
        //fontWeight: FontWeight.bold,
      ),
    ));

    if (_isLoading) {
      content = Center(
          child: Container(
        width: 70,
        height: 70,
        child: RefreshProgressIndicator(
          color: Color.fromARGB(113, 249, 247, 252),
          backgroundColor: Color.fromARGB(39, 62, 10, 154).withOpacity(.0),
        ),
      ));
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (ctx, item) => Dismissible(
                key: ValueKey(_groceryItems[item].id),
                onDismissed: (direction) {
                  _removeitem(_groceryItems[item]);
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
              ));
    }
    if (_error != null) {
      content = Center(
          child: Text(
        _error!,
        style: TextStyle(
          color: Color.fromARGB(113, 249, 247, 252),
          fontSize: 30,
          //fontWeight: FontWeight.bold,
        ),
            textAlign: TextAlign.center,
      ));
    }

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
      body: content,
    );
  }
}

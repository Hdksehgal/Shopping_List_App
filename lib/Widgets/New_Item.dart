import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list_app/Data/Categories.dart';
import 'package:shopping_list_app/Models/category_model.dart';
import 'package:shopping_list_app/Models/grocery_item.dart';

class NewItem extends StatefulWidget {
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  var _selectedName = '';
  var _selectedQuantity = 1;
  var _selectedCategory = categories[Categories.sweets];

  final _formkey = GlobalKey<FormState>();
  // difference between a Globalkey and a ValueKey is
  // global key gives easy access to the connected widget
  // and also ensures when the build method is executed again then
  // the connected widget i.e.Form will not be rebuilt
  // and can keep its internal state cause example it is
  // internal state that will tell the flutter whether to show
  // some validation errors on the screen or not

  // Globalkey is a generic type that's why we added the FormState
  // to be more specific and also this will give us some extra type
  // checking and auto completion suggestions

  void _saveItem() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      Navigator.of(context).pop(
          GroceryItem(
          id: DateTime.now().toString(),
          name: _selectedName,
          quantity: _selectedQuantity,
          category: _selectedCategory!)
      );
    }
    //_formkey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lets add a new item!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                // instead of TextField
                // because we are using Form which validates the
                // TextFormField , TextFormField is an extended version
                // of TextField with some extra features like validator
                maxLength: 50,
                initialValue: _selectedName,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  label: Text("Name"),
                ),
                validator: (str) {
                  if (str == null ||
                      str.length == null ||
                      str.trim().length <= 1 ||
                      str.trim().length > 50)
                    return "No. of characters should be between 2 to 50";
                  return null;
                },
                onSaved: (str) {
                  _selectedName = str!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      //maxLength: 2,
                      decoration:
                          const InputDecoration(label: Text('Quantity')),
                      initialValue: _selectedQuantity.toString(),
                      validator: (str) {
                        if (str == null ||
                            str.length == null ||
                            int.tryParse(str) == null ||
                            int.tryParse(str)! <= 0) // for positive number
                          return "enter a valid-positive number";
                        return null;
                        //int.tryparse convert the string into int number and also
                        //checks whether the string content has valid numbers in it
                        //example if the string has '1fgf' the conversion will be unsucessful
                        //and hence returns null
                      },
                      onSaved: (str) {
                        _selectedQuantity = int.parse(str!);
                        // int.parse is used to convert string into int value
                        // whereas int.tryparse throws an error on the unsucessful
                        // conversion
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        value: _selectedCategory,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    height: 14,
                                    width: 14,
                                    color: category.value.indicate,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(category.value.grocery)
                                ],
                              ),
                            )
                        ],
                        onChanged: (value) {
                          _selectedCategory = value;
                        }),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        _formkey.currentState!.reset();
                      },
                      child: const Text('Reset')),
                  ElevatedButton(
                      onPressed: _saveItem, child: const Text('Add Item')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:nutrition_tracker/nndsearch.dart';
import 'package:nutrition_tracker/pages/search_results.dart';
import 'package:nutrition_tracker/user.dart';
import 'package:nutrition_tracker/database/custom_list.dart';
import 'package:nutrition_tracker/fooditem.dart';

class SearchPage extends StatefulWidget {
  User user;

  SearchPage({Key key, @required this.user}) : super(key: key);

  @override
  _SearchPage createState() => new _SearchPage();
}

class _SearchPage extends State<SearchPage> {

  NNDCommunicator nnd = new NNDCommunicator("rzS3XGZhYjJWf9KBj4mwNYCzhQ4XqF2Y0qi7TjW2");

  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
  }

  Future<bool> _back(BuildContext context) async{
    return true;
  }


  final List<String> categories = ["Breakfast", "Lunch", "Snack", "Dinner"];

  String category = "Breakfast";

  void onChanged(String value){
    setState((){
      category = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    User _user = widget.user;
    return new WillPopScope(
      onWillPop: () => _back(context),
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Food Search'),
        ),
        body: new Center(
          child: new Container(
            child: new ListView(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey[300],
                    hintText: 'Please enter a food name'
                  ),
                  controller: textController,
                ),

                RadioListTile<String>(
                title: Text(categories[0]),
                value: categories[0].toString(),
                groupValue: category,
                activeColor: Colors.lightBlue,
                onChanged: (String value) { onChanged(value); },
              ),
                RadioListTile<String>(
                  title: Text(categories[1]),
                  value: categories[1].toString(),
                  groupValue: category,
                  activeColor: Colors.lightBlue,
                  onChanged: (String value) { onChanged(value); },
                ),
                RadioListTile<String>(
                  title: Text(categories[2]),
                  value: categories[2].toString(),
                  groupValue: category,
                  activeColor: Colors.lightBlue,
                  onChanged: (String value) { onChanged(value); },
                ),
                RadioListTile<String>(
                  title: Text(categories[3]),
                  value: categories[3].toString(),
                  groupValue: category,
                  activeColor: Colors.lightBlue,
                  onChanged: (String value) { onChanged(value); },
                ),
              ],
            )
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
              nnd.search(textController.text, 25, 1).then((results) async {
                if (results == null) {
                  var customList = CustomList();
                  List<FoodItem> customFoods = await customList
                      .searchCustomList(textController.text);
                  if (customFoods.length > 0)
                    Navigator.of(context).push(new PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            SearchResultsPage(items: null,
                                numItems: customFoods.length,
                                user: _user,
                                category: category,
                                foodList: customFoods,
                                isNND: false))
                    );
                }
                else {
                  Navigator.of(context).push(new PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          SearchResultsPage(items: results,
                              numItems: results.getTotal(),
                              user: _user,
                              category: category,
                              foodList: null,
                              isNND: true))
                  );
                }
                //Navigator.of(context, rootNavigator: true).pop(user);
              });
          },
        ),
      ),
    );
  }
}
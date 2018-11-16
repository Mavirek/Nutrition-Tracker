import 'package:flutter/material.dart';
import 'dart:async';
import 'package:nutrition_tracker/nndsearch.dart';
import 'package:nutrition_tracker/pages/search_results.dart';
import 'package:nutrition_tracker/user.dart';
import 'package:nutrition_tracker/database/custom_list.dart';
import 'package:nutrition_tracker/fooditem.dart';

class SearchPage extends StatelessWidget {
  User _user;
  String category;
  SearchPage(this._user, this.category);

  NNDCommunicator nnd = new NNDCommunicator("rzS3XGZhYjJWf9KBj4mwNYCzhQ4XqF2Y0qi7TjW2");

  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
  }

  Future<bool> _back(BuildContext context) async{
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
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
              ],
            )
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            nnd.search(textController.text,25,1).then((results) async {
              //print("is results null? "+(results==null).toString());
              if(results==null) {
                print("search failed");
                var customList = CustomList();
                List<FoodItem> customFoods = await customList.searchCustomList(textController.text);
                if(customFoods.length>0)
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
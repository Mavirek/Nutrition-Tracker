import 'package:flutter/material.dart';
import 'package:nutrition_tracker/nndsearch.dart';
import 'nutrition_facts.dart';
import 'package:nutrition_tracker/fooditem.dart';
import 'package:nutrition_tracker/user.dart';
import 'package:nutrition_tracker/pages/category.dart';

class SearchResultsPage extends StatefulWidget {
  final int numItems;
  final NNDSearchResults items;
  final User user;
  
  SearchResultsPage({Key key, @required this.items, @required this.numItems, @required this.user}) : super(key: key);
  @override
  _SearchResultsPageState createState() => new _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  int radiovalue1 = 0;
  String category = "BREAKFAST";
  
  NNDCommunicator nnd = new NNDCommunicator("rzS3XGZhYjJWf9KBj4mwNYCzhQ4XqF2Y0qi7TjW2");

  @override
  Widget build(BuildContext context){
    int numItems = widget.numItems;
    User user = widget.user;
    NNDSearchResults items = widget.items;
    return MaterialApp(
      title: 'Search Results',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Search Results'),
        ),
        body: ListView.builder(
          itemCount: numItems,
          itemBuilder: (BuildContext context, int index) {
            return new ListTile(
              title: new Text(items.getItem(index).name),
              subtitle: new Text(items.getItem(index).group + "\n"+items.getItem(index).dataSource+"\n"+'${items.getItem(index).ndbno}'+"\n"+items.getItem(index).manufacturer),
              enabled: true,
              onTap: () async {
                FoodItem food = await nnd.getItem(items.getItem(index).ndbno);
                _showFacts(context, food, user);
                //Category(food: food, user: user);
                //await NutritionFactsPage.setFood(nnd, items.getItem(index).ndbno);
                //Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (_, __, ___) => NutritionFactsPage()));
              },
            );
          },
        )
      ),
    );
  }

  void _handleChange(int value) {
    setState(() {
      radiovalue1 = value;
      print("radio = "+radiovalue1.toString());
      switch(radiovalue1) {
        case 0:
          category = "BREAKFAST";
          break;
        case 1:
          category = "LUNCH";
          break;
        case 2:
          category = "SNACK";
          break;
        case 3:
          category = "DINNER";
          break;
      }
    });
  }

  void _showFacts(BuildContext context, FoodItem ft, User user){
    var alert = new AlertDialog(
      title: Text(ft.getName()),
      content: Text('Calores: ' + ft.calories.toString() + '\nCarbs: ' + ft.carbs.toString() + '\nFat: ' + ft.fat.toString() + '\nProtein: ' + ft.protein.toString()),
      actions: <Widget>[
        new Center(
          child:new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Radio(value: 0, groupValue: radiovalue1, onChanged: _handleChange),
                  new Text('Breakfast'),
                ],
              ),
              new Row(
                children: <Widget>[
                  new Radio(value: 1, groupValue: radiovalue1, onChanged: _handleChange),
                  new Text('Lunch'),
                ],
              ),
              new Row(
                children: <Widget>[
                  new Radio(value: 2, groupValue: radiovalue1, onChanged: _handleChange),
                  new Text('Snack'),
                ],
              ),
              new Row(
                children: <Widget>[
                  new Radio(value: 3, groupValue: radiovalue1, onChanged: _handleChange),
                  new Text('Dinner'),
                ],
              ),
              new Row(
                children: <Widget>[
                  new FlatButton(
                    child: new Text('CANCEL'),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text('ADD'),
                    onPressed: () async {
                      ft.setCategory(category);
                      await user.dailyCal.addFoodItem(ft);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  )
                ],
              )
            ],
          ),
        )
      ],

    );
    showDialog(context: context, builder: (context) => alert);
  }
}
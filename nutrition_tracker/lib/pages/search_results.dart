import 'package:flutter/material.dart';
import 'package:nutrition_tracker/nndsearch.dart';
import 'nutrition_facts.dart';
import 'package:nutrition_tracker/fooditem.dart';
import 'package:nutrition_tracker/user.dart';

class SearchResultsPage extends StatelessWidget{
  final int numItems;
  final NNDSearchResults items;
  final User _user;
  int radiovalue1 = -1;
  int radiovalue2 = -1;
  int radiovalue3 = -1;
  int radiovalue4 = -1;


  SearchResultsPage(NNDSearchResults results,int itemTotal, User user) : items = results, numItems = itemTotal, _user = user;

  NNDCommunicator nnd = new NNDCommunicator("rzS3XGZhYjJWf9KBj4mwNYCzhQ4XqF2Y0qi7TjW2");

  @override
  Widget build(BuildContext context){
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
                _showFacts(context, food);
                //await NutritionFactsPage.setFood(nnd, items.getItem(index).ndbno);
                //Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (_, __, ___) => NutritionFactsPage()));
              },
            );
          },
        )
      ),
    );
  }

  void _showFacts(BuildContext context, FoodItem ft){
    String category = 'BREAKFAST';
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
                  new Radio(value: 0, groupValue: -1, onChanged: (int) {
                    category = 'BREAKFAST';
                    return 0;
                  }),
                  new Text('Breakfast'),
                ],
              ),
              new Row(
                children: <Widget>[
                  new Radio(value: 1, groupValue: -1, onChanged: (int) {
                    category = 'LUNCH';
                    return 1;
                  }),
                  new Text('Lunch'),
                ],
              ),
              new Row(
                children: <Widget>[
                  new Radio(value: 2, groupValue: -1, onChanged: (int) {
                    category = 'SNACK';
                    return 2;
                  }),
                  new Text('Snack'),
                ],
              ),
              new Row(
                children: <Widget>[
                  new Radio(value: 3, groupValue: -1, onChanged: (int) {
                    category = 'DINNER';
                    return 3;
                  }),
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
                      await _user.dailyCal.addFoodItem(ft);
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
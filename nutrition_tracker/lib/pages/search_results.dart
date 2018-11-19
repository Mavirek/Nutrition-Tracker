import 'package:flutter/material.dart';
import 'package:nutrition_tracker/nndsearch.dart';
import 'nutrition_facts.dart';
import 'package:nutrition_tracker/fooditem.dart';
import 'package:nutrition_tracker/user.dart';
import 'package:nutrition_tracker/pages/category.dart';
import 'package:firebase_database/firebase_database.dart';


class SearchResultsPage extends StatefulWidget {
  final int numItems;
  final NNDSearchResults items;
  final User user;
  final String category;
  final List<FoodItem> foodList;
  final bool isNND;


  SearchResultsPage({Key key, @required this.items, @required this.numItems, @required this.user, @required this.category, @required this.foodList, @required this.isNND}) : super(key: key);
  @override
  _SearchResultsPageState createState() => new _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  int radiovalue1 = 0;
  final reference = FirebaseDatabase.instance.reference();
  NNDCommunicator nnd = new NNDCommunicator("rzS3XGZhYjJWf9KBj4mwNYCzhQ4XqF2Y0qi7TjW2");

  Future<bool> _back(BuildContext context) async{
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context){
    int numItems = widget.numItems;
    User user = widget.user;
    NNDSearchResults items = widget.items;
    String category = widget.category;
    List<FoodItem> customFoods = widget.foodList;
    return new WillPopScope(
      onWillPop: () => _back(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search Results'),
        ),
        body: ListView.builder(
          itemCount: numItems,
          itemBuilder: (BuildContext context, int index) {
            if(widget.isNND)
            {
              return new ListTile(
                title: new Text(items.getItem(index).name),
                subtitle: new Text(items.getItem(index).group + "\n"+items.getItem(index).dataSource+"\n"+'${items.getItem(index).ndbno}'+"\n"+items.getItem(index).manufacturer),
                enabled: true,
                onTap: () async {
                  FoodItem food = await nnd.getItem(items.getItem(index).ndbno);
                  food.setCategory(category);

                  _showFacts(context, food, user);
                  //Category(food: food, user: user);
                  //await NutritionFactsPage.setFood(nnd, items.getItem(index).ndbno);
                  //Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (_, __, ___) => NutritionFactsPage()));
                },
              );
            }
            else
            {
              return new ListTile(
                title: new Text(customFoods[index].getName()),
                subtitle: new Text("Calories: "+customFoods[index].getCalories().toString() + "\n"+"Carbs: "+customFoods[index].getCarbs().toString()+"\n"+"Protein: "+customFoods[index].getProtein().toString()+"\n"+"Fats: "+customFoods[index].getFat().toString()),
                enabled: true,
                onTap: () async {
                  customFoods[index].setCategory(category);

                  _showFacts(context, customFoods[index], user);
                  //Category(food: food, user: user);
                  //await NutritionFactsPage.setFood(nnd, items.getItem(index).ndbno);
                  //Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (_, __, ___) => NutritionFactsPage()));
                },
              );
            }
          },
        )
      ),
    );
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                      await user.addTodaysCal(ft);
                      reference.child(user.displayName).set(user.toJson());
                      Navigator.of(context, rootNavigator: true).pop(user);
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
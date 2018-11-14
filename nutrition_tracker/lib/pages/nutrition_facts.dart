import 'package:flutter/material.dart';
import 'package:nutrition_tracker/fooditem.dart';
import 'package:nutrition_tracker/nndsearch.dart';

class NutritionFactsPage extends StatelessWidget {
  static FoodItem food;
  final NNDCommunicator nnd = new NNDCommunicator("rzS3XGZhYjJWf9KBj4mwNYCzhQ4XqF2Y0qi7TjW2");

  static Future<FoodItem> setFood(NNDCommunicator nnd, int ndbno) async {
    food = await nnd.getItem(ndbno);
    return food;
  }

  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Nutrition Facts',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(food.getName()),
        ),
        body: new Column(
          children: <Widget>[
            new Text(food.getName()),
            new Text("Category: "+food.getCategory()),
            new Text("Calories: "+food.getCalories().toString()),
            new Text("Carbs: "+food.getCarbs().toString()),
            new Text("Protein: "+food.getProtein().toString()),
            new Text("Fat: "+food.getFat().toString()),
          ],
        ),
      ),
     );
  }
}
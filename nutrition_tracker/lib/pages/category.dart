import 'package:flutter/material.dart';
import 'package:nutrition_tracker/fooditem.dart';
import 'package:nutrition_tracker/user.dart';

class Category extends StatefulWidget {
  final FoodItem food;
  final User user;

  Category({Key key, @required this.food, @required this.user}) : super(key: key);
  @override
  _CategoryState createState() => new _CategoryState();
//  @override
//  State<StatefulWidget> createState() {
//    return new _CategoryState();
//  }
}

class _CategoryState extends State<Category> {
  int radiovalue1 = -1;

  @override
  Widget build(BuildContext context) {
    FoodItem ft = widget.food;
    User _user = widget.user;
    String category = 'BREAKFAST';
    var alert = AlertDialog(
      title: Text(ft.getName()),
      content: Text('Calores: ' + ft.calories.toString() + '\nCarbs: ' + ft.carbs.toString() + '\nFat: ' + ft.fat.toString() + '\nProtein: ' + ft.protein.toString()),
      actions: <Widget>[
        new Center(
          child:new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Radio(value: 0, groupValue: radiovalue1, onChanged: (int) {
                    category = 'BREAKFAST';
                    return 0;
                  }),
                  new Text('Breakfast'),
                ],
              ),
              new Row(
                children: <Widget>[
                  new Radio(value: 1, groupValue: radiovalue1, onChanged: (int) {
                    category = 'LUNCH';
                    return 1;
                  }),
                  new Text('Lunch'),
                ],
              ),
              new Row(
                children: <Widget>[
                  new Radio(value: 2, groupValue: radiovalue1, onChanged: (int) {
                    category = 'SNACK';
                    return 2;
                  }),
                  new Text('Snack'),
                ],
              ),
              new Row(
                children: <Widget>[
                  new Radio(value: 3, groupValue: radiovalue1, onChanged: (int) {
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
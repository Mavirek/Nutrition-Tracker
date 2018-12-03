import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:nutrition_tracker/user.dart';
import 'package:nutrition_tracker/fooditem.dart';
import 'package:nutrition_tracker/dailycal.dart';

class ChangeFoodPage extends StatelessWidget {
  User _user;
  final reference = FirebaseDatabase.instance.reference();
  final DateTime today;

  ChangeFoodPage(this._user) :
        today = _stripTime(DateTime.now());

  static DateTime _stripTime(DateTime dt) {
    return new DateTime(dt.year, dt.month, dt.day);
  }

  Future<bool> _back(BuildContext context) async {
    await reference.child(_user.displayName).set(_user.toJson());
    return true;
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _back(context),
        child: new Scaffold(
            appBar: new AppBar(
                title: Text("Change Foods")
            ),
            body: new ListView(
              children: <Widget>[
                buildDayList(context, today),
                buildDayList(context, today.subtract(Duration(days: 1))),
                buildDayList(context, today.subtract(Duration(days: 2))),
                buildDayList(context, today.subtract(Duration(days: 3))),
                buildDayList(context, today.subtract(Duration(days: 4))),
                buildDayList(context, today.subtract(Duration(days: 5))),
                buildDayList(context, today.subtract(Duration(days: 6))),
              ],
              shrinkWrap: true,
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => print("Add button works"),
              icon: Icon(Icons.add),
              label: Text("Add missing food")
            )
        )
    );
  }

  buildDayList(BuildContext context, DateTime day) {
    List<FoodItem> foodItems = _user.dailyCal.items[day];
    List<ListTile> foodRows = foodItems != null ? foodItems.map((item) {
      return new ListTile(
          title: new Text(item.name),
          trailing: IconButton(
            icon: new Icon(Icons.clear),
            tooltip: 'Remove food item',
            onPressed: () => print("Remove button works"),
          )
      );
    }).toList() : [];
    List<Widget> listChildren = <Widget>[
      new Text(
          new DateFormat.MMMMd().format(day),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          )
      ),
    ];
    listChildren.addAll(foodRows);
    return new ListView(
      children: listChildren,
      shrinkWrap: true,
    );
  }
}
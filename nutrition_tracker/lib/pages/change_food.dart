import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:nutrition_tracker/user.dart';
import 'package:nutrition_tracker/fooditem.dart';
import 'package:nutrition_tracker/dailycal.dart';

class ChangeFoodPage extends StatefulWidget {
  User user;

  ChangeFoodPage({Key key, @required this.user}) :
        super(key: key);

  ChangeFoodPageState createState() => new ChangeFoodPageState();
}

class ChangeFoodPageState extends State<ChangeFoodPage> {
  User _user;
  final reference = FirebaseDatabase.instance.reference();
  DateTime today;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    today = _stripTime(DateTime.now());
  }

  static DateTime _stripTime(DateTime dt) {
    return new DateTime(dt.year, dt.month, dt.day);
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
        )
    );
  }

  Future<bool> _back(BuildContext context) async {
    await reference.child(_user.displayName).set(_user.toJson());
    return true;
  }

  buildDayList(BuildContext context, DateTime day) {
    List<FoodItem> foodItems = _user.dailyCal.items[day];
    List<ListTile> foodRows = foodItems != null ? foodItems.map((item) {
      return new ListTile(
          title: new Text(item.name),
          trailing: IconButton(
            icon: new Icon(Icons.clear),
            tooltip: 'Remove food item',
            onPressed: () => removeFoodItem(context, day, item),
          )
      );
    }).toList() : [];
    List<Widget> listChildren = <Widget>[
      new ListTile(
          title: new Text(
              new DateFormat.MMMMd().format(day),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
              )
          ),
          trailing: day != today ? IconButton(
              icon: new Icon(Icons.add),
              tooltip: 'Add calories',
              onPressed: () => addCalories(context, day)
          ) : null
      )
    ];
    listChildren.addAll(foodRows);
    return new ListView(
      children: listChildren,
      shrinkWrap: true,
    );
  }

  void removeFoodItem(BuildContext context, DateTime day, FoodItem item) {
    AlertDialog dialog = AlertDialog(
        title: Text('Are you sure you want to remove ' + item.name + "?"),
        actions: <Widget>[
          FlatButton(
              child: Text('Yes'),
              onPressed: () {
                _user.dailyCal.items[day].remove(item);
                setState(() {});
                Navigator.of(context, rootNavigator: true).pop();
              }
          ),
          FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop()
          )
        ]
    );
    showDialog(context: context, builder: (context) => dialog);
  }

  void addCalories(BuildContext context, DateTime day) {
    GlobalKey<FormState> formKey = new GlobalKey<FormState>();
    TextEditingController controller = new TextEditingController();
    TextFormField calorieInput = TextFormField(
        keyboardType: TextInputType.number,
        controller: controller,
        validator: (input) {
          try {
            final int parsed = int.parse(input);
          } catch (e) {
            return "Calories must be a positive whole number.";
          }
          return null;
        }
    );
    AlertDialog dialog = AlertDialog(
        title: Text("Enter your number of calories"),
        content: new Form(
            key: formKey,
            child: calorieInput
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Add'),
              onPressed: () {
                if (formKey.currentState.validate()) {
                  _user.dailyCal.addFoodItemForDay(new FoodItem(
                      "Manual Calorie Addition",
                      int.parse(controller.text),
                      0,
                      0,
                      0
                  ), day);
                  setState(() {});
                } else
                  print("Validation failed.");
                Navigator.of(context, rootNavigator: true).pop();
              }
          ),
          FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop()
          )
        ]
    );
    showDialog(context: context, builder: (context) => dialog);
  }

}
import 'package:flutter/material.dart';
import 'package:nutrition_tracker/user.dart';
import 'package:firebase_database/firebase_database.dart';

class StatsPage extends StatelessWidget {

  User user;
  final reference = FirebaseDatabase.instance.reference();

  StatsPage(this.user);

  Future<bool> _back(BuildContext context) async{
    //Will need to write User object to firebase before going back!!
    reference.child(user.displayName).set(user.toJson());
    Navigator.of(context).pop(true);
  }

  Widget build(BuildContext context){
    return new WillPopScope(
      onWillPop: () => _back(context),
      child: new Scaffold(
        appBar: new AppBar(
          title: Text('User Statistics'),
        ),
        body: new Column(
          children: <Widget>[
            new SizedBox(height: 75.0,),
            new Row(
              children: <Widget>[
                Expanded(
                  child: new Text("Your Saved Height: " + user.currentHeight.toString() + ' Ft', style: new TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic)),
                ),
                RaisedButton(
                  child: Text("Update Height"),
                  onPressed: () => _showHeightDialog(context),
                ),
              ],
            ),
            new SizedBox(height: 70.0,),
            new Row(
              children: <Widget>[
                Expanded(
                  child: new Text("Your Saved Weight: " + user.currentWeight.toString(), style: new TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic)),
                ),
                RaisedButton(
                  child: Text("Update Weight"),
                  onPressed: () => _showWeightDialog(context),
                ),
              ],
            ),
            new SizedBox(height: 70.0,),
            new Row(
              children: <Widget>[
                Expanded(
                  child: new Text("Your Saved Goal: " + user.goal.toString() + ' Calories Per Day', style: new TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic)),
                ),
                RaisedButton(
                  child: Text("Update Goal"),
                  onPressed: () => _showGoalDialog(context),
                ),
              ],
            )
          ],
        ),
      )
    );
  }

  void _showHeightDialog(BuildContext context){
    final control = TextEditingController();
    var alert = new AlertDialog(
      title: Text('Update Height'),
      content: TextFormField(
        validator: (value) {
          if(value.isEmpty){
            return 'Please enter some text';
          }
          try{
            final num = int.parse(value);
          }catch (e){
            return '"$value" is not a valid number';
          }

          final num = int.parse(value);
          if(num > 8 || num < 0)
            return '"$value" is not a valid height';
          return null;
        },
        controller: control,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: 'Enter Your Height in Feet'
        ),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              user.updateCurrentHeight(int.parse(control.text));
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('Save')
        )
      ],
    );

    showDialog(context: context, builder: (context) => alert);
  }

  void _showWeightDialog(BuildContext context) {
    final control = TextEditingController();
    var alert = new AlertDialog(
        title: Text('Update Weight'),
        content: TextFormField(
        validator: (value) {
          if(value.isEmpty){
            return 'Please enter some text';
          }
          try{
            final num = int.parse(value);
          }catch (e){
            return '"$value" is not a valid number';
          }

          return null;
        },
        controller: control,
        keyboardType: TextInputType.number,
          decoration: InputDecoration(
              hintText: 'Enter Your new Weight'
          ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            user.updateCurrentWeight(int.parse(control.text));
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text('Save')
        )
      ],
    );

    showDialog(context: context, builder: (context) => alert);
  }

  void _showGoalDialog(BuildContext context) {
    final control = TextEditingController();
    var alert = new AlertDialog(
      title: Text('Update Goal'),
      content: TextFormField(
        validator: (value) {
          if(value.isEmpty){
            return 'Please enter some text';
          }
          try{
            final num = int.parse(value);
          }catch (e){
            return '"$value" is not a valid number';
          }

          return null;
        },
        controller: control,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: 'Enter Your Daily Caloric Goal'
        ),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              user.updateGoal(int.parse(control.text));
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('Save')
        )
      ],
    );

    showDialog(context: context, builder: (context) => alert);
  }
}


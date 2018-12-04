import 'package:flutter/material.dart';
import 'package:nutrition_tracker/user.dart';
import 'package:firebase_database/firebase_database.dart';

class StatsPage extends StatelessWidget {

  User user;
  final reference = FirebaseDatabase.instance.reference();

  StatsPage(this.user);

  Future<bool> _back(BuildContext context) async{
    //Will need to write User object to firebase before going back!!
    await reference.child(user.displayName).set(user.toJson());
    return true;
  }

  Widget build(BuildContext context){
    return new WillPopScope(
      onWillPop: () => _back(context),
      child: new Scaffold(
        appBar: new AppBar(
          title: Text('User Statistics'),
        ),
        body: new ListView(
          children: <Widget>[
            new Card(
              child: new Column(
                children: <Widget>[
                  new Text("Your Saved Age: " + user.age.toString() + ' Years', style: new TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic)),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text("Update Age"),
                          onPressed: () => _showAgeDialog(context),
                        )
                      ],
                    ),
                  )
                ],

              )

            ),
            new Card(
              child: new Column(
                children: <Widget>[
                  new Text("Your Saved Height: " + user.currentHeight.toString() + ' Cm', style: new TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic)),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text("Update Height"),
                          onPressed: () => _showHeightDialog(context),
                        )
                      ],
                    ),
                  )
                ],

              )
            ),
            new Card(
              child: new Column(
                children: <Widget>[
                  new Text("Your Saved Weight: " + user.currentWeight.toString(), style: new TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic)),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text("Update Weight"),
                          onPressed: () => _showWeightDialog(context),
                        )
                      ],
                    ),
                  )
                ],

              )
            ),
            new Card(
              child: new Column(
                children: <Widget>[
                  new Text("Your Saved Goal: " + user.goal.toString() + ' Calories Per Day', style: new TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic)),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text("Update Goal"),
                          onPressed: () => _showGoalDialog(context),
                        )
                      ],
                    ),
                  )
                ],

              )
            ),
            new Card(
              child: new Column(
                children: <Widget>[
                  sex(),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text("Update Sex"),
                          onPressed: () => _showSexDialog(context),
                        )
                      ],
                    ),
                  )
                ],

              )
            )
          ],
        )
      )
    );
  }

  Widget sex() {
    if(user.isMale()){
      return new Text("Your sex is Male.", style: new TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),);
    }
    return new Text("Your sex is Female.", style: new TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),);
  }

  void _showSexDialog(BuildContext context){
    final control = TextEditingController();
    var alert = new AlertDialog(
      title: Text('Change Sex'),
      content: TextFormField(
        validator: (value) {
          if(value.isEmpty){
            return 'Please enter M for Male or F for Female';
          }

          final num = int.parse(value);
          if(num != 1)
            return '"$value" is not a valid value';
          return null;
        },
        controller: control,
        decoration: InputDecoration(
            hintText: 'Please enter M for Male or F for Female'
        ),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              user.updateSex(control.text.toString().toUpperCase() == 'M');
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('Save')
        )
      ],
    );

    showDialog(context: context, builder: (context) => alert);
  }

  void _showAgeDialog(BuildContext context){
    final control = TextEditingController();
    var alert = new AlertDialog(
      title: Text('Update Age'),
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
            return '"$value" is not a valid age';
          return null;
        },
        controller: control,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: 'Enter Your age in Year'
        ),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              user.updateAge(double.parse(control.text).round());
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('Save')
        )
      ],
    );

    showDialog(context: context, builder: (context) => alert);
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
            hintText: 'Enter Your Height in Centimeters'
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
            user.currentWeight = int.parse(control.text);
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
            final num = double.parse(value);
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


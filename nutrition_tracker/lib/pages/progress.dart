import 'package:flutter/material.dart';
import 'package:nutrition_tracker/user.dart';
import 'package:charts_flutter/flutter.dart';


class ProgressPage extends StatelessWidget {
  User _user;

  ProgressPage(this._user);

  Future<bool> _back(BuildContext context) async{
    return true;
  }

  @override
  Widget build(BuildContext context){
    return new WillPopScope(
      onWillPop: () => _back(context),
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Weight and Caloric Intake Progress'),
        ),
        body: new Center(
          child: new Container(
              child: new ListView(
                children: <Widget>[
                  
                ],
              )
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:nutrition_tracker/user.dart';
import 'package:firebase_database/firebase_database.dart';

class ChangeFoodPage extends StatelessWidget {
  User _user;
  final reference = FirebaseDatabase.instance.reference();

  ChangeFoodPage(this._user);

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
            body: new Text("Test")
        )
    );
  }
}
import 'package:flutter/material.dart';
import 'auth/login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'Nutrition Tracker',
      home: new LoginPage(),
    );
  }
}



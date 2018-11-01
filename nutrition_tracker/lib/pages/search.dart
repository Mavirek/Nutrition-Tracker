import 'package:flutter/material.dart';
import 'dart:async';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Search Page',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Food Search'),
        ),
        body: new Center(
          child: new Container(
            child: new ListView(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey[300],
                    hintText: 'Please enter a food name'
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
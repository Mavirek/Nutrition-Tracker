import 'package:flutter/material.dart';
import 'dart:async';
import 'package:nutrition_tracker/nndsearch.dart';
import 'package:nutrition_tracker/pages/search_results.dart';
import 'package:nutrition_tracker/user.dart';

class SearchPage extends StatelessWidget {
  User _user;

  SearchPage(this._user);

  NNDCommunicator nnd = new NNDCommunicator("rzS3XGZhYjJWf9KBj4mwNYCzhQ4XqF2Y0qi7TjW2");

  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
  }

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
                  controller: textController,
                ),
              ],
            )
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            nnd.search(textController.text,25,1).then((results){
              Navigator.of(context).push(new PageRouteBuilder(
                  pageBuilder: (_, __, ___) => SearchResultsPage(items: results, numItems: results.getTotal(), user: _user))
              );
            });
          },
        ),
      ),
    );
  }
}
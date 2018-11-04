import 'package:flutter/material.dart';
import 'package:nutrition_tracker/database/custom_list.dart';
import 'package:nutrition_tracker/fooditem.dart';
import 'dart:async';

class CustomListPage extends StatelessWidget {

  Future<List<FoodItem>> fetchFoodItems() async{
    var customList = CustomList();
    return customList.getFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'CustomList',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom List'),
        ),
        body: new Container(
          padding: new EdgeInsets.all(16.0),
          child: new FutureBuilder<List<FoodItem>>(
            future: fetchFoodItems(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(snapshot.data[index].name),
                        new Text(snapshot.data[index].calories.toString()),
                        new Text(snapshot.data[index].getMacros()[0].toString()),
                        new Text(snapshot.data[index].getMacros()[1].toString()),
                        new Text(snapshot.data[index].getMacros()[2].toString()),
                        new Divider()
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
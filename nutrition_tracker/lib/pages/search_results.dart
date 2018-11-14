import 'package:flutter/material.dart';
import 'package:nutrition_tracker/nndsearch.dart';
import 'nutrition_facts.dart';
import 'package:nutrition_tracker/fooditem.dart';

class SearchResultsPage extends StatelessWidget{
  final int numItems;
  final NNDSearchResults items;

  SearchResultsPage(NNDSearchResults results,int itemTotal) : items = results, numItems = itemTotal;

  NNDCommunicator nnd = new NNDCommunicator("rzS3XGZhYjJWf9KBj4mwNYCzhQ4XqF2Y0qi7TjW2");

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Search Results',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Search Results'),
        ),
        body: ListView.builder(
          itemCount: numItems,
          itemBuilder: (context, index) {
            return new ListTile(
              title: new Text(items.getItem(index).name),
              subtitle: new Text(items.getItem(index).group + "\n"+items.getItem(index).dataSource+"\n"+'${items.getItem(index).ndbno}'+"\n"+items.getItem(index).manufacturer),
              enabled: true,
              onTap: () async {
                //items.getItem(index).ndbno
                //FoodItem food = await nnd.getItem(21246);
                Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (_, __, ___) => NutritionFactsPage(items.getItem(index).ndbno)));

//                nnd.getItem(14601).then((food) {
//                  Navigator.of(context).push(new PageRouteBuilder(pageBuilder: (_, __, ___) => NutritionFactsPage(food)));
//                });
              },
            );
          },
        )
      ),
    );
  }
}
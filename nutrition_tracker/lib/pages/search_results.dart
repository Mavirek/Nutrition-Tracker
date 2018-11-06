import 'package:flutter/material.dart';
import 'package:nutrition_tracker/nndsearch.dart';

class SearchResultsPage extends StatelessWidget{
  final int numItems;
  final NNDSearchResults items;

  SearchResultsPage(NNDSearchResults results,int itemTotal) : items = results, numItems = itemTotal;


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
            return new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(items.getItem(index).name),
                new Text(items.getItem(index).group),
                new Text(items.getItem(index).dataSource),
                new Text('${items.getItem(index).ndbno}'),
                new Text(items.getItem(index).manufacturer),
                new Divider(height: 20.0),
              ],
            );
          },
        )
      ),
    );
  }
}
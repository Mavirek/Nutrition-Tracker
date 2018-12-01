import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:nutrition_tracker/user.dart';


class MyProgressPage extends StatefulWidget {
  User user;
  final String title;

  MyProgressPage(this.title, this.user);

  @override
  _MyProgressPageState createState() => new _MyProgressPageState();
}

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class CaloriesPerDay {
  final String dt;
  final int calories;
  final charts.Color color;

  CaloriesPerDay(this.dt, this.calories, Color color) : this.color = new charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class _MyProgressPageState extends State<MyProgressPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    DateTime sevDays = DateTime.now().subtract(new Duration(days: 7));
    DateTime sixDays = DateTime.now().subtract(new Duration(days: 6));
    DateTime fivDays = DateTime.now().subtract(new Duration(days: 5));
    DateTime fouDays = DateTime.now().subtract(new Duration(days: 4));
    DateTime thrDays = DateTime.now().subtract(new Duration(days: 3));
    DateTime twoDays = DateTime.now().subtract(new Duration(days: 2));
    DateTime oneDays = DateTime.now().subtract(new Duration(days: 1));
    DateTime today = DateTime.now();
    var data = [
      new CaloriesPerDay(sevDays.toString().substring(0, 10), user.dailyCal.getDailyCal(sevDays), Colors.blue),
      new CaloriesPerDay(sixDays.toString().substring(0, 10), user.dailyCal.getDailyCal(sixDays), Colors.blue),
      new CaloriesPerDay(fivDays.toString().substring(0, 10), user.dailyCal.getDailyCal(fivDays), Colors.blue),
      new CaloriesPerDay(fouDays.toString().substring(0, 10), user.dailyCal.getDailyCal(fouDays), Colors.blue),
      new CaloriesPerDay(thrDays.toString().substring(0, 10), user.dailyCal.getDailyCal(thrDays), Colors.blue),
      new CaloriesPerDay(twoDays.toString().substring(0, 10), user.dailyCal.getDailyCal(twoDays), Colors.blue),
      new CaloriesPerDay(oneDays.toString().substring(0, 10), user.dailyCal.getDailyCal(oneDays), Colors.blue),
      new CaloriesPerDay(today.toString().substring(0, 10), user.dailyCal.getDailyCal(today), Colors.blue),
//      new ClicksPerYear('2016', 12, Colors.red),
//      new ClicksPerYear('2017', 42, Colors.yellow),
//      new ClicksPerYear('2018', _counter, Colors.green),

    ];

    var series = [
//      new charts.Series(
//        domainFn: (ClicksPerYear clickData, _) => clickData.year,
//        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
//        colorFn: (ClicksPerYear clickData, _) => clickData.color,
//        id: 'Clicks',
//        data: data,
//      ),
      new charts.Series(
        domainFn: (CaloriesPerDay calDate, _) => calDate.dt,
        measureFn: (CaloriesPerDay calDate, _) => calDate.calories,
        colorFn: (CaloriesPerDay calDate, _) => calDate.color,
        id: 'Calories',
        data: data,
      ),
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
      vertical: false,
    );
    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            chartWidget,
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
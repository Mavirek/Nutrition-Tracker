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


class CaloriesPerDay {
  final String dt;
  final int calories;
  final charts.Color color;

  CaloriesPerDay(this.dt, this.calories, Color color) : this.color = new charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class WeightPerDay {
  final DateTime dt;
  final int weight;
  final charts.Color color;

  WeightPerDay(this.dt, this.weight, Color color) : this.color = new charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
class _MyProgressPageState extends State<MyProgressPage> {
  List<WeightPerDay> list = new List();
  
  void add(DateTime day, int weight) {
    list.add(new WeightPerDay(day, weight, Colors.blue));
  }
  
  void setWeightData(User user){
    Map<DateTime, int> map = user.archiveWeight;

    map.forEach(add);
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
      new CaloriesPerDay(sevDays.toString().substring(5, 10), user.dailyCal.getDailyCal(sevDays), Colors.blue),
      new CaloriesPerDay(sixDays.toString().substring(5, 10), user.dailyCal.getDailyCal(sixDays), Colors.blue),
      new CaloriesPerDay(fivDays.toString().substring(5, 10), user.dailyCal.getDailyCal(fivDays), Colors.blue),
      new CaloriesPerDay(fouDays.toString().substring(5, 10), user.dailyCal.getDailyCal(fouDays), Colors.blue),
      new CaloriesPerDay(thrDays.toString().substring(5, 10), user.dailyCal.getDailyCal(thrDays), Colors.blue),
      new CaloriesPerDay(twoDays.toString().substring(5, 10), user.dailyCal.getDailyCal(twoDays), Colors.blue),
      new CaloriesPerDay(oneDays.toString().substring(5, 10), user.dailyCal.getDailyCal(oneDays), Colors.blue),
      new CaloriesPerDay(today.toString().substring(5, 10), user.dailyCal.getDailyCal(today), Colors.blue),
    ];

    var goalData = [
      new CaloriesPerDay(sevDays.toString().substring(5, 10), user.goal, Colors.blue),
      new CaloriesPerDay(sixDays.toString().substring(5, 10), user.goal, Colors.blue),
      new CaloriesPerDay(fivDays.toString().substring(5, 10), user.goal, Colors.blue),
      new CaloriesPerDay(fouDays.toString().substring(5, 10), user.goal, Colors.blue),
      new CaloriesPerDay(thrDays.toString().substring(5, 10), user.goal, Colors.blue),
      new CaloriesPerDay(twoDays.toString().substring(5, 10), user.goal, Colors.blue),
      new CaloriesPerDay(oneDays.toString().substring(5, 10), user.goal, Colors.blue),
      new CaloriesPerDay(today.toString().substring(5, 10), user.goal, Colors.blue),
    ];

    var series = [
      new charts.Series(
        domainFn: (CaloriesPerDay calDate, _) => calDate.dt,
        measureFn: (CaloriesPerDay calDate, _) => calDate.calories,
        colorFn: (CaloriesPerDay calDate, _) => calDate.color,
        id: 'Calories',
        data: data,
      ),
      new charts.Series(
        domainFn: (CaloriesPerDay calDate, _) => calDate.dt,
        measureFn: (CaloriesPerDay calDate, _) => calDate.calories,
        colorFn: (CaloriesPerDay calDate, _) => calDate.color,
        id: 'Goal',
        data: goalData)..setAttribute(charts.rendererIdKey, 'GoalLine'),
    ];


    var chart = new charts.OrdinalComboChart(
      series,
      animate: true,
      defaultRenderer: new charts.BarRendererConfig(groupingType: charts.BarGroupingType.grouped),
      customSeriesRenderers: [
        new charts.LineRendererConfig(
          customRendererId: 'GoalLine'
        )
      ],
    );
    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );

    setWeightData(user);
    var weightData = list;
    var weightSeries = [
      new charts.Series<WeightPerDay, DateTime>(
          id: 'Weight Line',
          colorFn: (_,__) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (WeightPerDay weight, _) => weight.dt,
          measureFn: (WeightPerDay weight, _) => weight.weight,
          data: weightData
      ),
      new charts.Series<WeightPerDay, DateTime>(
        id: 'Points0',
        colorFn: (_,__) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (WeightPerDay weight, _) => weight.dt,
        measureFn: (WeightPerDay weight, _) => weight.weight,
        data: weightData)..setAttribute(charts.rendererIdKey, 'Points')
    ];
    var weightChart = new charts.TimeSeriesChart(
      weightSeries,
      animate: true,
      defaultRenderer: new charts.LineRendererConfig(),
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      customSeriesRenderers: [new charts.PointRendererConfig(
        customRendererId: 'Points'
      )],
    );
    var chartWidget2 = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: weightChart,
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            chartWidget,
            chartWidget2
          ],
        ),
      ),
    );
  }
}
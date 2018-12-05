import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:nutrition_tracker/user.dart';
import 'dart:collection';


class MyProgressPage extends StatefulWidget {
  User user;
  final String title;

  MyProgressPage(this.title, this.user);

  @override
  _MyProgressPageState createState() => new _MyProgressPageState();
}

class CaloriesPerWeek{
  final DateTime dt;
  final int calories;
  final charts.Color color;

  CaloriesPerWeek(this.dt, this.calories, Color color) : this.color = new charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
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
  List<CaloriesPerWeek> calList = new List();
  void add(DateTime day, int weight) {
    list.add(new WeightPerDay(day, weight, Colors.blue));
  }
  
  void setWeightData(User user){
    Map<DateTime, int> map = new SplayTreeMap.from(user.archiveWeight,
        (dt1, dt2) => dt1.compareTo(dt2));

    map.forEach(add);
  }

  void addWeek(DateTime day, int cal){
    calList.add(new CaloriesPerWeek(day, cal, Colors.blue));
  }
  void setWeekData(User user){
    Map<DateTime, int> map = new SplayTreeMap.from(user.weeklyCal,
            (dt1, dt2) => dt1.compareTo(dt2));

    map.forEach(addWeek);
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
    String sevDay = sevDays.toString().substring(5, 7)+"\n"+sevDays.toString().substring(8, 10);
    String sixDay = sixDays.toString().substring(5, 7)+"\n"+sixDays.toString().substring(8, 10);
    String fivDay = fivDays.toString().substring(5, 7)+"\n"+fivDays.toString().substring(8, 10);
    String fouDay = fouDays.toString().substring(5, 7)+"\n"+fouDays.toString().substring(8, 10);
    String thrDay = thrDays.toString().substring(5, 7)+"\n"+thrDays.toString().substring(8, 10);
    String twoDay = twoDays.toString().substring(5, 7)+"\n"+twoDays.toString().substring(8, 10);
    String oneDay = oneDays.toString().substring(5, 7)+"\n"+oneDays.toString().substring(8, 10);
    String tody = today.toString().substring(5, 7)+"\n"+today.toString().substring(8, 10);
    var data = [
      new CaloriesPerDay(sevDay, user.dailyCal.getDailyCal(sevDays), Colors.blue),
      new CaloriesPerDay(sixDay, user.dailyCal.getDailyCal(sixDays), Colors.blue),
      new CaloriesPerDay(fivDay, user.dailyCal.getDailyCal(fivDays), Colors.blue),
      new CaloriesPerDay(fouDay, user.dailyCal.getDailyCal(fouDays), Colors.blue),
      new CaloriesPerDay(thrDay, user.dailyCal.getDailyCal(thrDays), Colors.blue),
      new CaloriesPerDay(twoDay, user.dailyCal.getDailyCal(twoDays), Colors.blue),
      new CaloriesPerDay(oneDay, user.dailyCal.getDailyCal(oneDays), Colors.blue),
      new CaloriesPerDay(tody, user.dailyCal.getDailyCal(today), Colors.blue),
    ];

    var goalData = [
      new CaloriesPerDay(sevDay, user.goal, Colors.blue),
      new CaloriesPerDay(sixDay, user.goal, Colors.blue),
      new CaloriesPerDay(fivDay, user.goal, Colors.blue),
      new CaloriesPerDay(fouDay, user.goal, Colors.blue),
      new CaloriesPerDay(thrDay, user.goal, Colors.blue),
      new CaloriesPerDay(twoDay, user.goal, Colors.blue),
      new CaloriesPerDay(oneDay, user.goal, Colors.blue),
      new CaloriesPerDay(tody, user.goal, Colors.blue),
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

    setWeekData(user);
    var weekData = calList;
    var weekSeries = [
      new charts.Series<CaloriesPerWeek, DateTime>(
          id: 'Weekly Calories Line',
          colorFn: (_,__) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (CaloriesPerWeek week, _) => week.dt,
          measureFn: (CaloriesPerWeek week, _) => week.calories,
          data: weekData
      ),
      new charts.Series<CaloriesPerWeek, DateTime>(
          id: 'Points2',
          colorFn: (_,__) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (CaloriesPerWeek week, _) => week.dt,
          measureFn: (CaloriesPerWeek week, _) => week.calories,
          data: weekData)..setAttribute(charts.rendererIdKey, 'Points2')
    ];
    var weekChart = new charts.TimeSeriesChart(
      weekSeries,
      animate: true,
      defaultRenderer: new charts.LineRendererConfig(),
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      customSeriesRenderers: [new charts.PointRendererConfig(
          customRendererId: 'Points2'
      )],
    );
    var chartWidget2 = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: weekChart,
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
    var chartWidget3 = new Padding(
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
            new Divider(),
            new Text("Daily Caloric Intake",  textAlign: TextAlign.center,),
            chartWidget,
            new Divider(color: Colors.lightBlue,),
            new Text("Weekly Caloric Intake",  textAlign: TextAlign.center,),
            chartWidget2,
            new Divider(color: Colors.lightBlue,),
            new Text("Weight Progress",  textAlign: TextAlign.center,),
            chartWidget3,
          ],
        ),
      ),
    );
  }
}
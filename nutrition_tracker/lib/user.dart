import "dailycal.dart";
import "fooditem.dart";
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';

const Duration WEEK = Duration(days: 7);

const double LBS_TO_KGS = 0.45359237;

class User {
  int _currentHeight, _currentWeight, age;
  int goal;
  String displayName;
  Map<DateTime, int> _archiveWeight;
  Map<DateTime, int> _weeklyCal;
  bool metric, sex;
  final DailyCal _cal;
  File _currentPhoto, _previousPhoto;

  User.fromScratch() :
        _currentHeight = 0,
        _currentWeight = 0,
        _currentPhoto = new File(""),
        _previousPhoto = new File(""),
        age = 0,
        sex = true,
        _archiveWeight = new Map<DateTime, int>(),
        goal = 0,
        metric = false,
        _cal = new DailyCal.fromScratch(),
        _weeklyCal = new Map<DateTime, int>();

  User.fromExisting(this._currentHeight, this._currentWeight, this._archiveWeight, this.goal, this.metric, this._cal);

  User.fromJSON(String name, Map<dynamic, dynamic> map) :
        displayName = name,
        age = map["Age"],
        sex = map["Sex"],
        _currentHeight = map["Current Height"],
        _currentWeight = map["Current Weight"],
        _archiveWeight = map["Archive Weight"] != null ? map["Archive Weight"].map<DateTime, int>((dynamic k, dynamic value) {
          return new MapEntry<DateTime, int>(DateTime.fromMillisecondsSinceEpoch(int.parse(k)), value);
        }) : new Map<DateTime, int>(),
        goal = map["Goal"],
        metric = map["Metric"],
        _previousPhoto = map.containsKey("before") ? File(map["Before"]) : File(""),
        _currentPhoto = map.containsKey("after") ? File(map["After"]) : File(""),
        _cal = map["Daily Calories"] != "empty" ? new DailyCal.fromJSON(map["Daily Calories"]) : new DailyCal.fromScratch(),
        _weeklyCal = map.containsKey("Weekly Calories") ? map["Weekly Calories"].map<DateTime, int>((dynamic k, dynamic value) {
          return new MapEntry<DateTime, int>(DateTime.fromMillisecondsSinceEpoch(int.parse(k)), value);
        }) : new Map<DateTime, int>() {
    _cleanByWeek();
  }

  get currentHeight => _currentHeight;
  get archiveWeight {
    if (metric)
      return _archiveWeight.map((key, value) => MapEntry(key, (value * LBS_TO_KGS).round()));
    else
      return _archiveWeight;
  }

  set currentHeight(int newHeight) {
    if (newHeight >= 0) {
      _currentHeight = newHeight;
      goalCalculator();
    }
    else
      throw new ArgumentError("Height should not be negative.");
  }

  get currentWeight => metric ? (_currentWeight * LBS_TO_KGS).round() : _currentWeight;
  set currentWeight(int newWeight) {
    if (newWeight >= 0) {
      newWeight = metric ? (newWeight / LBS_TO_KGS).round() : newWeight;
      _currentWeight = newWeight;
      _archiveWeight[DateTime.now()] = newWeight;
      goalCalculator();
    } else
      throw new ArgumentError("Weight should not be negative.");
  }

  get weeklyCal {
    Map<DateTime, int> result = Map<DateTime, int>.from(_weeklyCal);
    _cal.items.forEach((key, value) {
      int total = 0;
      value.forEach((item) => total += item.calories);
      DateTime newKey = key.subtract(Duration(days:key.weekday));
      if (result.containsKey(newKey))
        result[newKey] += total;
      else
        result[newKey] = total;
    });
    return result;
  }

  void setDisplayName(String name){
    displayName = name;
  }

  get currentPhoto => _currentPhoto;
  get previousPhoto => _previousPhoto;
  set currentPhoto(File newPhoto) {
    _previousPhoto = previousPhoto;
    _currentPhoto = newPhoto;
  }


  get dailyCal => _cal;
  addTodaysCal(FoodItem item) {
    _cal.addFoodItem(item);
  }

  bool isMale(){
    return sex;
  }

  void updatePhoto(File newPhoto){
    _previousPhoto = _currentPhoto;
    _currentPhoto = newPhoto;
  }

  void updateSex(bool sex){
    this.sex = sex;
    goalCalculator();
  }

  void updateAge(int newAge) {
    if (newAge >= 0 ) {
      age = newAge;
      goalCalculator();
    }
    else
      throw new ArgumentError("Age Should not be negative.");
  }
  void updateCurrentHeight(int newHeight) {
    if (newHeight >= 0) {
      _currentHeight = newHeight;
      goalCalculator();
    }
    else
      throw new ArgumentError("Height should not be negative.");
  }

  void updateCurrentWeight(int newWeight) {
    if (newWeight >= 0) {
      _currentWeight = newWeight;
      archiveWeight[DateTime.now()] = newWeight;
      goalCalculator();
    } else
      throw new ArgumentError("Weight should not be negative.");
  }

  void updateGoal(int newGoal) {
    if(newGoal >= 0){
      goal = newGoal;
    } else
      throw new ArgumentError("Goal should not be negative.");
  }

  void goalCalculator(){
    double weightKG = _currentWeight * LBS_TO_KGS;
    if(isMale())
      goal = ((weightKG * 10) + (6.25 * currentHeight) - (5 * age) + 5).round();
    else
      goal = ((weightKG * 10) + (6.25 * currentHeight) - (5 * age) - 161).round();
  }

  toJson() {
    dynamic result = {
      "Age": age,
      "Sex": sex,
      "Current Height": _currentHeight,
      "Current Weight": _currentWeight,
      "Goal": goal,
      "Before": previousPhoto.path,
      "After": currentPhoto.path,
      "Metric": metric,
      "Archive Weight": _archiveWeight.map<dynamic, dynamic>(
        (DateTime key, int value) {
          return new MapEntry<dynamic, dynamic>(key.millisecondsSinceEpoch.toString(), value);
        }
      ),
      "Weekly Calories": _weeklyCal.map<dynamic, dynamic>(
              (DateTime key, int value) {
            return new MapEntry<dynamic, dynamic>(key.millisecondsSinceEpoch.toString(), value);
          }
      ),
      "Daily Calories": _cal.toJSON()
    };
    print(result);
    return result;
  }

  get weightUnit => metric ? "kgs." : "lbs.";

  DateTime _stripTime(DateTime dt) {
    return new DateTime(dt.year, dt.month, dt.day);
  }

  void _cleanByWeek() {
    DateTime today = _stripTime(DateTime.now());
    DateTime weekOld = today.subtract(WEEK);
    Map<DateTime, List<FoodItem>> removed = Map<DateTime, List<FoodItem>>.fromEntries(
      _cal.items.entries.where((e) => e.key.isBefore(weekOld))
    );
    _cal.items.removeWhere((key, value) => key.isBefore(weekOld));

    Map<DateTime, int> dailyTotals = removed.map<DateTime, int>((key, value) {
      int total = 0;
      value.forEach((item) => total += item.calories);
      return MapEntry<DateTime, int>(key, total);
    });

    dailyTotals.forEach((key, value) {
      DateTime newKey = key.subtract(new Duration(days: key.weekday));
      if (_weeklyCal.containsKey(newKey))
        _weeklyCal[newKey] += value;
      else
        _weeklyCal[newKey] = value;
    });
  }
}
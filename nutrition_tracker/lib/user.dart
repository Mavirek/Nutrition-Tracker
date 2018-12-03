import "dailycal.dart";
import "fooditem.dart";
import 'package:firebase_database/firebase_database.dart';

const int MICROSECONDS_PER_DAY = 86400000000;

class User {
  int _currentHeight, _currentWeight, goal;
  String displayName;
  Map<DateTime, int> _archiveWeight;
  Map<DateTime, int> _weeklyCal;
  bool metric;
  final DailyCal _cal;
  // Photo _currentPhoto, _previousPhoto

  User.fromScratch() :
        _currentHeight = 0,
        _currentWeight = 0,
        _archiveWeight = new Map<DateTime, int>(),
        goal = 0,
        metric = false,
        _cal = new DailyCal.fromScratch(),
        _weeklyCal = new Map<DateTime, int>();

  User.fromExisting(this._currentHeight, this._currentWeight, this._archiveWeight, this.goal, this.metric, this._cal);

  User.fromJSON(String name, Map<dynamic, dynamic> map) :
      displayName = name,
      _currentHeight = map["Current Height"],
      _currentWeight = map["Current Weight"],
      _archiveWeight = map["Archive Weight"] != null ? map["Archive Weight"].map<DateTime, int>((dynamic k, dynamic value) {
        return new MapEntry<DateTime, int>(DateTime.fromMillisecondsSinceEpoch(int.parse(k)), value);
      }) : new Map<DateTime, int>(),
      goal = map["Goal"],
      metric = map["Metric"],
      _cal = map["Daily Calories"] != "empty" ? new DailyCal.fromJSON(map["Daily Calories"]) : new DailyCal.fromScratch(),
      _weeklyCal = map["Weekly Calories"] != null ? map["Weekly Calories"].map<DateTime, int>((dynamic k, dynamic value) {
        return new MapEntry<DateTime, int>(DateTime.fromMillisecondsSinceEpoch(int.parse(k)), value);
      }) : new Map<DateTime, int>();

  get currentHeight => _currentHeight;
  get archiveWeight => _archiveWeight;
  set currentHeight(int newHeight) {
    if (newHeight >= 0)
      _currentHeight = newHeight;
    else
      throw new ArgumentError("Height should not be negative.");
  }

  get currentWeight => _currentWeight;
  set currentWeight(int newWeight) {
    if (newWeight >= 0) {
      _currentWeight = newWeight;
      archiveWeight[DateTime.now()] = newWeight;
    } else
      throw new ArgumentError("Weight should not be negative.");
  }

  get weeklyCal => _weeklyCal;

  void setDisplayName(String name){
    displayName = name;
  }
  /*
  get currentPhoto => _currentPhoto;
  get previousPhoto => _previousPhoto;
  set currentPhoto(Photo newPhoto) {
    _previousPhoto = previousPhoto;
    _currentPhoto = newPhoto;
  }
  */

  get dailyCal => _cal;
  addTodaysCal(FoodItem item) {
    _cal.addFoodItem(item);
  }

  void updateCurrentHeight(int newHeight) {
    if (newHeight >= 0)
      _currentHeight = newHeight;
    else
      throw new ArgumentError("Height should not be negative.");
  }

  void updateCurrentWeight(int newWeight) {
    if (newWeight >= 0) {
      _currentWeight = newWeight;
      archiveWeight[DateTime.now()] = newWeight;
    } else
      throw new ArgumentError("Weight should not be negative.");
  }

  void updateGoal(int newGoal) {
    if(newGoal >= 0){
      goal = newGoal;
    } else
      throw new ArgumentError("Goal should not be negative.");
  }

  toJson() {
    return {
      "Current Height": _currentHeight,
      "Current Weight": _currentWeight,
      "Goal": goal,
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
  }
}
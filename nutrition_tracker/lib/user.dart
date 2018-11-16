import "dailycal.dart";
import "fooditem.dart";

class User {
  int _currentHeight, _currentWeight, goal;
  String displayName;
  Map<DateTime, int> _archiveWeight;
  bool metric;
  final DailyCal _cal;
  // Photo _currentPhoto, _previousPhoto

  User.fromScratch() :
        _currentHeight = 0,
        _currentWeight = 0,
        _archiveWeight = new Map<DateTime, int>(),
        goal = 0,
        metric = false,
        _cal = new DailyCal.fromScratch();

  User.fromExisting(this._currentHeight, this._currentWeight, this._archiveWeight, this.goal, this.metric, this._cal);

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

  String toString() {
    // TODO Unable to implement without knowing necessary REST JSON format
    return null;
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
      "Archive Weight": _archiveWeight.map<String, dynamic>(
        (DateTime key, int value) {
          return new MapEntry<String, dynamic>(key.millisecondsSinceEpoch.toString(), value);
        }
      ),
      "Daily Calories": _cal.toJSON()
    };
  }
}
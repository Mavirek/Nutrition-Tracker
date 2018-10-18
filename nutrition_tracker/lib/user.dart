import "dailycal.dart";
import "fooditem.dart";

class User {
  int _currentHeight, _currentWeight, goal;
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
}
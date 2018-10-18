import "dailycal.dart";
import "fooditem.dart";

class User {
  int _currentHeight, _currentWeight, goal;
  bool metric;
  final DailyCal _cal;
  // Photo _currentPhoto, _previousPhoto

  User(this._currentHeight, this._currentWeight, this.goal, this.metric, this._cal);

  get currentHeight => _currentHeight;
  set currentHeight(int newHeight) {
    if (newHeight >= 0)
      _currentHeight = newHeight;
    else
      throw new ArgumentError("Height should not be negative.");
  }

  get currentWeight => _currentWeight;
  set currentWeight(int newWeight) {
    if (newWeight >= 0)
      _currentWeight = newWeight;
    else
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
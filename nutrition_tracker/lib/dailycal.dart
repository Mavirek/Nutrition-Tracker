import "fooditem.dart";

class DailyCal {
  Map items;

  DailyCal.fromScratch() {
    items = new Map<DateTime, List<FoodItem>>();
  }

  DailyCal.fromExisting(this.items);

  addFoodItem(FoodItem item) {
    addFoodItemForDay(item, DateTime.now());
  }

  addFoodItemForDay(FoodItem item, DateTime day) {
    day = _stripTime(day);

    if (items[day] == null)
      items[day] = new List<FoodItem>();

    items[day].add(item);
  }

  int getDailyCal(DateTime day) {
    day = _stripTime(day);
    int cal = 0;
    List<FoodItem> dayItems = items[day];

    if (dayItems == null)
      return 0;

    dayItems.forEach((item) => (cal += item.calories));
    return cal;
  }

  DateTime _stripTime(DateTime dt) {
    return new DateTime(dt.year, dt.month, dt.day);
  }
}
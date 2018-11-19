import "fooditem.dart";

class DailyCal {
  Map<DateTime, List<FoodItem>> items;


  DailyCal.fromScratch() {
    items = new Map<DateTime, List<FoodItem>>();
  }

  DailyCal.fromExisting(this.items);

  DailyCal.fromJSON(Map<dynamic, dynamic> json) {
    items = json.map<DateTime, List<FoodItem>>((dynamic key, dynamic value) {
        DateTime time = DateTime.fromMillisecondsSinceEpoch(int.parse(key));
        List<FoodItem> list = new List<FoodItem>();
        print("is value map = "+(value is Map).toString());
        value.forEach((v) => list.add(new FoodItem.fromJSON(v)));
        return MapEntry<DateTime, List<FoodItem>>(time, list);
      }
    );
  }

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

  int getTodaysCal() {
    return getDailyCal(DateTime.now());
  }

  List<FoodItem> getFoodForDay(DateTime day) {
    day = _stripTime(day);
    List<FoodItem> dayItems = items[day];
    if (dayItems != null)
      return new List<FoodItem>.from(dayItems);
    else
      return new List<FoodItem>();
  }

  DateTime _stripTime(DateTime dt) {
    return new DateTime(dt.year, dt.month, dt.day);
  }

  List<List<FoodItem>> getCategorizedList(){
    List<FoodItem> list = items[_stripTime(DateTime.now())];
    List<FoodItem> bfList = new List<FoodItem>();
    List<FoodItem> lhList = new List<FoodItem>();
    List<FoodItem> skList = new List<FoodItem>();
    List<FoodItem> drList = new List<FoodItem>();
    if(list == null)
      return [bfList, lhList, skList, drList];

    list.forEach((ft) {
      switch(ft.getCategory()){
        case "BREAKFAST": {
          bfList.add(ft);
        }
        break;
        case "LUNCH" : {
          lhList.add(ft);
        }
        break;
        case "SNACK": {
          skList.add(ft);
        }
        break;
        case "DINNER": {
          drList.add(ft);
        }
        break;
      }
    });
    return [bfList, lhList, skList, drList];
  }

  toJSON() {
    print(items);
    if (items.isNotEmpty)
      return items.map<String, dynamic>(
        (DateTime key, List<FoodItem> value) {
          return MapEntry<String, dynamic>(key.millisecondsSinceEpoch.toString(),
              value.asMap().map<String, dynamic>((int index, FoodItem item) {
                    return MapEntry<String, dynamic>(
                        index.toString(), item.toJSON());
                  }
              ));
        });
    else
      return "empty";
  }
}
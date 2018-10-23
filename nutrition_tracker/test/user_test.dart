import "package:test/test.dart";
import "../lib/user.dart";
import "../lib/dailycal.dart";
import "../lib/fooditem.dart";

// TODO Add error checks if possible
void main() {
  group ('User class', ()
  {
    test('Constructor and getters work as intended', () {
      User u = new User.fromExisting(100, 100, null, 100, false, null);
      expect(u.currentHeight, 100);
      expect(u.currentWeight, 100);
      expect(u.archiveWeight, null);
      expect(u.goal, 100);
      expect(u.metric, false);
      expect(u.dailyCal, null);
    });

    test('Current height setter works.', () {
      User u = new User.fromExisting(100, 100, null, 100, false, null);
      u.currentHeight = 110;
      expect(u.currentHeight, 110);
    });

    test('Current weight setter works.', () {
      User u = new User.fromScratch();
      u.currentWeight = 110;
      expect(u.currentWeight, 110);
      expect(u.archiveWeight.length, 1);
    });

    test('DailyCal works with user correctly', () {
      User u = new User.fromScratch();
      FoodItem f = new FoodItem("Thing", 100, 0, 0, 0);
      u.addTodaysCal(f);
      expect(u.dailyCal.getTodaysCal(), 100);
    });
  });

  group('DailyCal class', () {
    test('Constructors work', () {
      DailyCal c = new DailyCal.fromScratch();
      DailyCal c2 = new DailyCal.fromExisting({});
      expect(c.getDailyCal(DateTime.now()), 0);
      expect(c2.getDailyCal(DateTime.now()), 0);
    });

    test('Return correctly with no food', () {
      DailyCal c = new DailyCal.fromScratch();
      expect(c.getDailyCal(new DateTime(2015, 1, 2)), 0);
    });

    test('Returns correct calorie information with some food', () {
      DailyCal c = new DailyCal.fromScratch();
      c.addFoodItem(new FoodItem("Blah", 100, 0, 0, 0));
      c.addFoodItem(new FoodItem("Blah2", 200, 0, 0, 0));
      expect(c.getTodaysCal(), 300);
    });

    test('Returns correct food list', () {
      DailyCal c = new DailyCal.fromScratch();
      expect(c.getFoodForDay(DateTime.now()).length, 0);

      FoodItem f1 = new FoodItem("F1", 0, 0, 0, 0);
      FoodItem f2 = new FoodItem("F2", 0, 0,0, 0);
      c.addFoodItem(f1);
      c.addFoodItem(f2);
      
      List<FoodItem> l = c.getFoodForDay(DateTime.now());
      expect(l.contains(f1), true);
      expect(l.contains(f2), true);
    });
  });
}
import "package:test/test.dart";
import "../lib/user.dart";
import "../lib/dailycal.dart";

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
      // TODO Unable to write without food item.
    });
  });

  group('DailyCal class', () {
    test('Constructors work', () {
      DailyCal c = new DailyCal.fromScratch();
      DailyCal c2 = new DailyCal.fromExisting({});
      expect(c.getDailyCal(DateTime.now()), 0);
      expect(c2.getDailyCal(DateTime.now()), 0);
    });
  });
}
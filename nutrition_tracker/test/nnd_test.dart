import "package:test/test.dart";

import "package:nutrition_tracker/nndsearch.dart";
import "package:nutrition_tracker/fooditem.dart";

const String apiKey = "rzS3XGZhYjJWf9KBj4mwNYCzhQ4XqF2Y0qi7TjW2";

void main() {
  group('Live test of NNDCommunicator', () {
    NNDCommunicator comm = new NNDCommunicator(apiKey);

    test('Test getFoodItem', () async {

      FoodItem f = await comm.getItem(21246);

      expect(f.name, "WENDY'S, Chicken Nuggets");
      expect(f.calories, 222);
      expect(f.protein, 11);
      expect(f.fat, 15);
      expect(f.carbs, 10);

    });

    test('search() basic test', () async {
      NNDSearchResults r = await comm.search("wendys", 25, 1);

      expect(r.start, 0);
      expect(r.end, 14);
      expect(r.total, 14);

      NNDSearchItem i = r.getItem(1);

      expect(i.name, "WENDY'S, Chicken Nuggets");
      expect(i.group, "Fast Foods");
      expect(i.dataSource, "SR");
      expect(i.ndbno, 21246);
      expect(i.manufacturer, "Wendy's International, Inc.");
    });

    test('search() page test', () async {
      NNDSearchResults pg2 = await comm.search("pizza", 25, 2);

      expect(pg2.start, 0);
      expect(pg2.end, 25);
      expect(pg2.total, 2691);

      // Item 29
      NNDSearchItem i = pg2.getItem(4);

      expect(i.name, "ARTISAN CRUST MEAT PIZZA, UPC: 688267155413");
    });

    test('NNDSearchResults access', () async {
      NNDSearchResults r = await comm.search("wendys", 25, 1);

      NNDSearchItem i = r[1];
      expect(i.ndbno, 21246);
    });
  });
}
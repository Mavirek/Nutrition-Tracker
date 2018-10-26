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
  });
}
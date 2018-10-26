import "dart:convert";
import 'package:http/http.dart';

import 'package:nutrition_tracker/fooditem.dart';

class NNDCommunicator {
  final String _apiKey;

  NNDCommunicator(String apiKey) : _apiKey = apiKey;

  Future<NNDSearchResults> search(String searchTerm, int itemsPerPage, int page) async {
    int offset = itemsPerPage * (page - 1);
    String url = "https://api.nal.usda.gov/ndb/search/?format=json&q=$searchTerm&sort=n&max=$itemsPerPage&offset=$offset&api_key=$_apiKey";
    Response response = await get(url);
    int statusCode = response.statusCode;
    String reason = response.reasonPhrase;

    if (statusCode == 200) {
      return new NNDSearchResults.fromJSON(json.decode(response.body)['list']);
    } else
      throw new Exception("HTTP GET EXCEPTION: $statusCode: $reason");
  }

  Future<FoodItem> getItem(int ndbno) async {
    String url = "https://api.nal.usda.gov/ndb/nutrients/?format=json&api_key=$_apiKey&nutrients=208&nutrients=205&nutrients=204&nutrients=203&ndbno=$ndbno";
    Response response = await get(url);
    int statusCode = response.statusCode;
    String reason = response.reasonPhrase;

    if (statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body)["report"]["foods"][0];
      String name = result['name'];
      int carbs, cals, protein, fat;

      for (Map<String, dynamic> nutrient in result['nutrients']) {
        switch(int.parse(nutrient['nutrient_id'])) {
          case 208: // Calories (technically energy)
            cals = int.parse(nutrient['value']);
            break;
          case 205: // Carbohydrates
            carbs = double.parse(nutrient['value']).round();
            break;
          case 204: // Fats (technically lipids)
            fat = double.parse(nutrient['value']).round();
            break;
          case 203: // Protein
            protein = double.parse(nutrient['value']).round();
            break;
        }
      }

      return new FoodItem(name, cals, carbs, fat, protein);

    } else
      throw new Exception("HTTP GET EXCEPTION: $statusCode: $reason");
  }
}

class NNDSearchResults {

  final List<NNDSearchItem> _items;
  final int start, end, total;

  NNDSearchResults.fromJSON(Map<String, dynamic> json)
      : _items = _genList(json["item"]), start = json['start'],
        end = json['end'], total = json['total'];

  static List<NNDSearchItem> _genList(List<dynamic> json) {
    List<NNDSearchItem> list = new List<NNDSearchItem>();
    for (Map<String, dynamic> e in json) {
      list.insert(e["offset"], new NNDSearchItem.fromJSON(e));
    }
    return list;
  }

  NNDSearchItem getItem(int index) {
    return _items[index];
  }

  operator [](index) => _items[index];
}

class NNDSearchItem {
  final String name;
  final String group;
  final int ndbno;
  final String dataSource;
  final String manufacturer;

  NNDSearchItem(this.name, this.group, this.ndbno, this.dataSource, this.manufacturer);

  NNDSearchItem.fromJSON(Map<String, dynamic> json)
      : name = json["name"],
        group = json["group"],
        ndbno = int.parse(json["ndbno"]),
        dataSource = json["ds"],
        manufacturer = json["manu"];
}
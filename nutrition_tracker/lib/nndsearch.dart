import 'package:http/http.dart';

import 'package:nutrition_tracker/fooditem.dart';

class NNDCommunicator {
  final String _apiKey;

  NNDCommunicator(String apiKey) : _apiKey = apiKey;

  Future<NNDSearchResults> search(String searchTerm, int itemsPerPage, int page) async {
    return null;
  }

  Future<FoodItem> getItem(int ndbno) async {
    return null;
  }
}

class NNDSearchResults {

  final List<NNDSearchItem> _items;
  final int start, end, total;

  NNDSearchResults.fromJSON(Map<String, dynamic> json)
      : _items = _genList(json), start = json['start'],
        end = json['end'], total = json['total'];

  static List<NNDSearchItem> _genList(Map<String, dynamic> json) {
    return null;
  }
}

class NNDSearchItem {
  final String name;
  final String group;
  final int ndbno;
  final String dataSource;
  final String manufacturer;

  NNDSearchItem(this.name, this.group, this.ndbno, this.dataSource, this.manufacturer);
}
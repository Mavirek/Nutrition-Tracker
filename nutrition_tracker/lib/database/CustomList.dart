import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nutrition_tracker/fooditem.dart';

class CustomList {
  static Database _db;
  static int foodID = 0;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name CustomList.db in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "CustomList.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name CustomList with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE CustomList(foodid INTEGER PRIMARY KEY, name TEXT, calories INTEGER, carbs INTEGER, fat INTEGER, protein INTEGER )");
    print("Created tables");
  }

//  int count() async {
//    var dbClient = await db;
//    return Sqflite.firstIntValue(await dbClient.transaction(txn) async {
//      txn.execute ('SELECT COUNT (*) FROM CustomList');
//    }
//  }

  // Retrieving FoodItems from CustomList Tables
  Future<List<FoodItem>> getFoodItems() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM CustomList');
    List<FoodItem> foodItems = new List();
    for (int i = 0; i < list.length; i++) {
      foodItems.add(new FoodItem(list[i]["name"], list[i]["calories"], list[i]["carbs"], list[i]["fat"], list[i]["protein"]));
    }
    print(foodItems.length);
    return foodItems;
  }

  void addCustomFoodItem(FoodItem foodItem) async {
    var dbClient = await db;
    List<int> macros = foodItem.getMacros();
    await dbClient.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO CustomList(foodid, name, calories, carbs, fat, protein ) VALUES(' +
              '\'' +
              foodID.toString() +
              '\'' +
              ',' +
              '\'' +
              foodItem.getName() +
              '\'' +
              ',' +
              '\'' +
              foodItem.getCalories().toString() +
              '\'' +
              ',' +
              '\'' +
              macros[0].toString() +
              '\'' +
              ',' +
              '\'' +
              macros[1].toString() +
              '\'' +
              ',' +
              '\'' +
              macros[2].toString() +
              '\'' +
              ')');
    });
    foodID++;
  }

  Future<List<FoodItem>> searchCustomList(String searchParams) async {
    var dbClient = await db;
    List<Map> list = await dbClient.query("CustomList", columns: ['*'], where: '"name" = ?', whereArgs: [searchParams]);
    List<FoodItem> foodItems = new List();
    for (int i = 0; i < list.length; i++) {
      foodItems.add(new FoodItem(list[i]["name"], list[i]["calories"], list[i]["carbs"], list[i]["fat"], list[i]["protein"]));
    }
    print(foodItems.length);
    return foodItems;
  }

}
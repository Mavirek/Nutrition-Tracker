import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:nutrition_tracker/pages/search.dart';
import 'custom_fooditem_add.dart';
import 'custom_list_page.dart';
import 'package:nutrition_tracker/user.dart';
import 'package:nutrition_tracker/fooditem.dart';
import 'stats.dart';
import 'package:firebase_database/firebase_database.dart';


class HomePage extends StatelessWidget {
  GoogleSignInAccount _currentUser;
  GoogleSignIn _googleSignIn;
  Future<DataSnapshot> _userFuture;
  User _user;
  List<List<FoodItem>> categorizedList;
  final reference = FirebaseDatabase.instance.reference();
  final List<String> categories = ["Breakfast", "Lunch", "Snack", "Dinner"];

  HomePage (this._currentUser, this._googleSignIn){
    _userFuture = reference.child(_currentUser.displayName).once();
    //Text Code for Home Screen Stuff. Can be ignored.
//    FoodItem fd1 = new FoodItem("Breakfast", 0, 0, 0, 0);
//    FoodItem fd2 = new FoodItem("Lunch", 0, 0, 0, 0);
//    FoodItem fd3 = new FoodItem("Snack", 0, 0, 0, 0);
//    FoodItem fd4 = new FoodItem("Dinner", 0, 0, 0, 0);
//    FoodItem fd5 = new FoodItem("India On Wheels", 200, 10, 10, 10);
//    fd1.setCategory("BREAKFAST");
//    fd2.setCategory("LUNCH");
//    fd3.setCategory("SNACK");
//    fd4.setCategory("DINNER");
//    fd5.setCategory("DINNER");
//    user.dailyCal.addFoodItem(fd1);
//    user.dailyCal.addFoodItem(fd2);
//    user.dailyCal.addFoodItem(fd3);
//    user.dailyCal.addFoodItem(fd4);
//    user.dailyCal.addFoodItem(fd5);
  }

  Future<Null> _handleSignOut(BuildContext context) async{
    //reference.child(_currentUser.displayName).set(_user.toJson());
    await _googleSignIn.disconnect();
    Navigator.pop(context);
  }


  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        title: 'Home Page',
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Nutrition Tracker'),
              actions: <Widget>[
                new IconButton(icon: Icon(Icons.lock), onPressed: () => _handleSignOut(context)),
              ],
            ),
            drawer: FutureBuilder<DataSnapshot>(
                  future: _userFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (_user == null) {
                        print(snapshot.data.value);
                        if (snapshot.data.value == null) {
                          _user = new User.fromScratch();
                          _user.displayName = _currentUser.displayName;
                        } else
                          _user = new User.fromJSON(
                              _currentUser.displayName, snapshot.data.value);
                        categorizedList = _user.dailyCal.getCategorizedList();
                        print("categorizedList size = "+categorizedList[0].length.toString());
                      }
                      return buildDrawer(context);
                    } else if (snapshot.hasError) {
                      // TODO Better error screen
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner
                    return CircularProgressIndicator();
                  },
                ),
            body: Center(
                child: FutureBuilder<DataSnapshot>(
                  future: _userFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (_user == null) {
                        print(snapshot.data.value);
                        if (snapshot.data.value == null) {
                          _user = new User.fromScratch();
                          _user.displayName = _currentUser.displayName;
                        } else
                          _user = new User.fromJSON(
                              _currentUser.displayName, snapshot.data.value);
                        categorizedList = _user.dailyCal.getCategorizedList();
                        print("categorizedList size = "+categorizedList[0].length.toString());
                      }
                      return buildBody();
                    } else if (snapshot.hasError) {
                      // TODO Better error screen
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner
                    return CircularProgressIndicator();
                  },
                )
            )
        )
    );
  }
  buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: new ListView(
              children: <Widget>[
                ListTile(
                  leading: GoogleUserCircleAvatar(identity: _currentUser),
                  isThreeLine: true,
                  title: Text(_currentUser.displayName, style: new TextStyle(color: Colors.white),),
                  subtitle: new Text(_currentUser.email + '\nCalories: ' + _user.dailyCal.getTodaysCal().toString() , style: new TextStyle(color: Colors.white),),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.timeline),
            title: Text('View Progress'),
            onTap: (){
              //            Navigator.of(context).push(new PageRouteBuilder(
              //                pageBuilder: (_, __, ___) => SearchPage()
              //            )
              //            );
            },
          ),
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text('Search Food'),
            onTap: (){
              _showCategories(context);
//                  Navigator.of(context).push(new PageRouteBuilder(
//                      pageBuilder: (_, __, ___) => SearchPage(_user)
//                    )
//                  );
            },
          ),
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text('Add Food'),
            onTap: (){
              Navigator.of(context).push(new PageRouteBuilder(
                  pageBuilder: (_, __, ___) => CustomFoodItemPage()
              )
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text('View Custom List'),
            onTap: (){
              Navigator.of(context).push(new PageRouteBuilder(
                  pageBuilder: (_, __, ___) => CustomListPage()
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('View Statistics Page'),
            onTap: (){
              Navigator.of(context).push(new PageRouteBuilder(
                  pageBuilder: (_, __, ___) => StatsPage(_user)
              ));
            },
          ),
        ],
      ),
    );
  }
  buildBody() {
    return new Column(
      children: <Widget>[
        ListTile(
          leading: GoogleUserCircleAvatar(identity: _currentUser),
          title: Text(_currentUser.displayName),
          subtitle: Text(_currentUser.email),
        ),
        Divider(color: Colors.lightBlue,),
        Text("Breakfast", style: new TextStyle(fontStyle: FontStyle.italic, fontSize: 15.0),),
        new Flexible(child:
        ListView.builder(
            itemCount: categorizedList[0].length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(categorizedList[0][index].getName()),
                onTap: () => _showFacts(context, categorizedList[0][index]),
              );
            }
        ),
        ),
        Divider(color: Colors.lightBlue,),
        Text("Lunch",  style: new TextStyle(fontStyle: FontStyle.italic, fontSize: 15.0),),
        new Flexible(child:
        ListView.builder(
            itemCount: categorizedList[1].length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(categorizedList[1][index].getName()),
                onTap: () => _showFacts(context, categorizedList[1][index]),
              );
            }
        ),
        ),
        Divider(color: Colors.lightBlue,),
        Text("Snack",  style: new TextStyle(fontStyle: FontStyle.italic, fontSize: 15.0),),
        new Flexible(child:
        ListView.builder(
            itemCount: categorizedList[2].length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(categorizedList[2][index].getName()),
                onTap: () => _showFacts(context, categorizedList[2][index]),
              );
            }
        ),
        ),
        Divider(color: Colors.lightBlue,),
        Text("Dinner",  style: new TextStyle(fontStyle: FontStyle.italic, fontSize: 15.0),),
        new Flexible(child:
        ListView.builder(
            itemCount: categorizedList[3].length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(categorizedList[3][index].getName()),
                onTap: () => _showFacts(context, categorizedList[3][index]),
              );
            }
        ),
        ),
      ],
    );
  }

  void _showCategories(BuildContext context){
    var alert = new AlertDialog(
      title: Text('Pick a Category'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child:ListView.builder(
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(categories[index]),
                    onTap: () {
                      Navigator.of(context).push(new PageRouteBuilder(
                          pageBuilder: (_, __, ___) => SearchPage(_user, categories[index])
                      )
                      );
                      //categorizedList = _user.dailyCal.getCategorizedList();
                    },
                  );
                },
                shrinkWrap: true,
              ),
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (context) => alert);
  }
  void _showFacts(BuildContext context, FoodItem ft){
    var alert = new AlertDialog(
      title: Text(ft.getName()),
      content: Text('Calores: ' + ft.calories.toString() + '\nCarbs: ' + ft.carbs.toString() + '\nFat: ' + ft.fat.toString() + '\nProtein: ' + ft.protein.toString()),
      actions: <Widget>[
        new FlatButton(
          child: new Text('OK'),
          onPressed: (){
            Navigator.of(context, rootNavigator: true).pop();
          },
        )
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }
}
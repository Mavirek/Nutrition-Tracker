import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:nutrition_tracker/pages/search.dart';
import 'custom_fooditem_add.dart';
import 'custom_list_page.dart';


class HomePage extends StatelessWidget {
  GoogleSignInAccount _currentUser;
  GoogleSignIn _googleSignIn;

  HomePage (this._currentUser, this._googleSignIn);


  Future<Null> _handleSignOut(BuildContext context) async{
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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: new ListView(
                  children: <Widget>[
                    new UserAccountsDrawerHeader(
                        currentAccountPicture: GoogleUserCircleAvatar(identity: _currentUser),
                        accountName: new Text(_currentUser.displayName),
                        accountEmail: new Text(_currentUser.email, overflow: TextOverflow.ellipsis,),
                    )
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
                  //Navigator.pop(context);
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
                  Navigator.pop(context);
                  Navigator.of(context).push(new PageRouteBuilder(
                      pageBuilder: (_, __, ___) => SearchPage()
                    )
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.fastfood),
                title: Text('Add Food'),
                onTap: (){
                  Navigator.pop(context);
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
                  Navigator.pop(context);
                  Navigator.of(context).push(new PageRouteBuilder(
                      pageBuilder: (_, __, ___) => CustomListPage()
                  )
                  );
                },
              ),
            ],
          ),
        ),
        body: new Center(
          child: new Container(
            child: new ListView(
              children: <Widget>[
                ListTile(
                  leading: GoogleUserCircleAvatar(identity: _currentUser),
                  title: Text(_currentUser.displayName),
                  subtitle: Text(_currentUser.email),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
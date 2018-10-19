import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

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
          title: new Text('Home Screen'),
          actions: <Widget>[
            new IconButton(icon: Icon(Icons.lock), onPressed: () => _handleSignOut(context)),
          ],
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
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class HomePage extends StatelessWidget {
  GoogleSignInAccount _currentUser;
  GoogleSignIn _googleSignIn;

  HomePage (GoogleSignInAccount _currentUser, GoogleSignIn _googleSignIn){
    this._currentUser = _currentUser;
    this._googleSignIn = _googleSignIn;
  }

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
          title: new Text('Welcome Home'),
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
                const Text("Signed in Successfully"),
                RaisedButton(
                  child: const Text("Sign Out"),
                  onPressed: () => _handleSignOut(context),
                )
              ],
            ),
          ),
        )
      )
    );
  }
}
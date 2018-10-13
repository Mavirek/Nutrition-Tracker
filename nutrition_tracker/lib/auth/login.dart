import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:nutrition_tracker/home.dart';

class LoginPage extends StatelessWidget {
  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'openid',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  GoogleSignInAccount _currentUser;

  Future<Null> _handleSignIn(BuildContext context) async{
    try{
      await _googleSignIn.signIn().then((GoogleSignInAccount account){
        _currentUser = account;
        Navigator.of(context).push(new PageRouteBuilder(
            pageBuilder: (_, __, ___) => HomePage(_currentUser, _googleSignIn)
          )
        );
      });
    } catch(error){
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'Login Page',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            'Login Page'
          ),
        ),
        body: new Container(
          child: new ListView(
            children: <Widget>[
              const Text("Please Sign In"),
              RaisedButton(
                child: const Text("Sign In"),
                onPressed: () => _handleSignIn(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
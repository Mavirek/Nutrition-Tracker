import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:nutrition_tracker/pages/home.dart';
import 'package:camera/camera.dart';

class LoginPage extends StatelessWidget {
  LoginPage();

  final GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'openid',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<Null> _handleSignIn(BuildContext context) async{
    try{
      await _googleSignIn.signIn().then((GoogleSignInAccount account){
        if (account != null)
//          Navigator.push(context, new PageRouteBuilder(
//              pageBuilder: (_, __, ___) => HomePage(currentUser: account, googleSignIn: _googleSignIn,)
//            )
          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => HomePage(currentUser: account, googleSignIn: _googleSignIn,))
        );
      });
    } catch(error){
      print('Inside the Handle Sign In!!!!!!');
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
          backgroundColor: Colors.blue,
        ),
        body: new Container(
          padding: EdgeInsets.only(top: 48.0, left: 24.0, right: 24.0),
          child: new ListView(
            children: <Widget>[
              new SizedBox(height: 100.0,),
              new Center(
                child: new Text("Welcome to Nutrition",
                  style: new TextStyle(
                      fontSize: 32.00,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              new Center(
                child: new Text("Tracker",
                  style: new TextStyle(
                      fontSize: 32.00,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              new SizedBox(height: 150.0,),
              new RaisedButton(
                key: new Key('LogInButton'),
                color: Colors.lightBlueAccent,
                child: new Text(
                  "Sign In",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                ),
                onPressed: () => _handleSignIn(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: [
    'email',
    'profile',
    'openid',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Nutrition Tracker',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.red,
      ),
      home: LogInPage()//new MyHomePage(title: 'Nutrition Tracker Log In Page'),
    );
  }
}
class LogInPage extends StatefulWidget {
  @override
  State createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  GoogleSignInAccount _currentUser;
  String _text;

  @override
  void initState(){
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account){
      setState((){
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }
  Future<Null> _handleSignIn() async{
    try{
      await _googleSignIn.signIn();
    } catch(error){
      print(error);
    }
  }

  Future<Null> _handleSignOut() async{
    _googleSignIn.disconnect();
  }

  Widget _buildBody() {
    if(_currentUser != null){
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) => MyHomePage()
//          )
//      );
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(identity: _currentUser),
            title: Text(_currentUser.displayName),
            subtitle: Text(_currentUser.email),
          ),
          const Text("Signed in Successfully"),
          RaisedButton(
            child: const Text("Sign Out"),
            onPressed: _handleSignOut,
          )
        ],
      );
    } else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("Please Sign In"),
          RaisedButton(
            child: const Text("Sign In"),
            onPressed: _handleSignIn,
          )
        ],
      );
    }

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(),
      ),
    );
  }
}
class MyHomePage extends StatelessWidget {
  Future<Null> _handleSignOut() async{
    _googleSignIn.disconnect();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _handleSignOut),
    );
  }
}



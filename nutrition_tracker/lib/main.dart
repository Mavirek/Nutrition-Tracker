import 'package:flutter/material.dart';
import 'auth/login.dart';
import 'package:camera/camera.dart';
import 'dart:async';

List<CameraDescription> cameras;

Future<Null> main() async {
  cameras = await availableCameras();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'Nutrition Tracker',
      home: new LoginPage(cameras),
    );
  }
}



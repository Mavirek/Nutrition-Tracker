import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:nutrition_tracker/user.dart';
import 'package:firebase_database/firebase_database.dart';

class PicturePage extends StatefulWidget {
  User user;
  final reference = FirebaseDatabase.instance.reference();

  PicturePage(this.user);

  @override
  _MyPicturePageState createState() => new _MyPicturePageState();
}

class _MyPicturePageState extends State<PicturePage>{
  File beforeImage;
  File currentImage;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      widget.user.updatePhoto(image);
      widget.reference.child(widget.user.displayName).set(widget.user.toJson());
//      beforeImage = currentImage;
//      currentImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Before/After Pictures'),
      ),
      body: new Center(
        child: new ListView(
          children: <Widget>[
            new Text('Before Image:', style: new TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic)),
            Center(
              child: widget.user.previousPhoto == null
                  ? new Text('No before image selected.', style: new TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic))
                  : new Image.file(widget.user.previousPhoto),
            ),
            new Text('After Image: ', style: new TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic)),
            Center(
              child: widget.user.currentPhoto == null
                  ? new Text('No after image selected.', style: new TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic))
                  : new Image.file(widget.user.currentPhoto),
            )
          ],
        )
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
}
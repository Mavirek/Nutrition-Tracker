import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';


class Photo extends StatefulWidget {
  List<CameraDescription> cameras;

  Photo (this.cameras);

  @override
  PhotoState createState() => PhotoState();
}


class PhotoState extends State<Photo> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = new CameraController(widget.cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return new Container();
    }

    return new AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: new CameraPreview(controller));
  }
}
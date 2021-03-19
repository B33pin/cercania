//import 'dart:io';
//
//import 'package:flutter/material.dart';
//import 'package:image_cropper/image_cropper.dart';
//import 'package:image_picker/image_picker.dart';
//
//class ImageCapture extends StatefulWidget{
//  @override
//  State<StatefulWidget> createState() {
//    return ImageCaptureState();
//  }
//
//}
//class ImageCaptureState extends State<ImageCapture>{
//  File _imageFile;
//
//  File _image;
//
//  Future getImage() async {
//    var image = await ImagePicker.pickImage(source: ImageSource.camera);
//
//    setState(() {
//      _image = image;
//    });
//  }
//  @override
//  Widget build(BuildContext context) {
//
//    Future<void> _pickImage(ImageSource source) async {
//      File selected = await ImagePicker.pickImage(source: source);
//      setState(() {
//        _imageFile = selected;
//      });
//    }
//
//    Future<void> _cropImage() async {
//      File cropped = await ImageCropper.cropImage(sourcePath: _imageFile.path, cropStyle: CropStyle.circle);
//      setState(() {
//        _imageFile = cropped ?? _imageFile;
//      });
//    }
//
//    void _clear(){
////      setState(() {
//        _imageFile = null;
//      });
//    }
//
//    return Scaffold(
//      bottomNavigationBar: BottomAppBar(
//        child: Row(
//          children: <Widget>[
//            IconButton(
//              icon: Icon(Icons.photo_camera),
//              onPressed: (){
//                getImage;
//               // _pickImage(ImageSource.camera);
//              },
//            ),
//            IconButton(
//              icon: Icon(Icons.image),
//              onPressed: (){
//                _pickImage(ImageSource.gallery);
//              },
//            )
//          ],
//        ),
//      ),
//    );
//  }
//
//}
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseStorageService {
  static Future<List<String>> uploadImages(List<String> paths ) async {
    List<String> uploadedImages = [];
    for (String image in paths) {
      String fileName = DateTime.now().toIso8601String();
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putFile(File(image));
      var url;
      await (await uploadTask.whenComplete(() {
        url = firebaseStorageRef.getDownloadURL();
      }));
      uploadedImages.add(url);
    }
    return uploadedImages;
  }

  static Future<String> uploadImage(String path) async {
    String fileName = DateTime.now().toIso8601String();
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(File(path));
    var url;
    await (await uploadTask.whenComplete(() {
      url = firebaseStorageRef.getDownloadURL();
    }));
    return url;
  }

  static Future deleteImage(String url) async{
    try {
      Reference firebaseStorageRef = await FirebaseStorage.instance
          .refFromURL(url);
      await firebaseStorageRef.delete();
    } catch (e){
      print(e);
      return;
    }
  }

  static Future deleteImages(List<String> urls) async{
    for(var url in urls){
      try {
        Reference firebaseStorageRef = await FirebaseStorage.instance
            .refFromURL(url);
        await firebaseStorageRef.delete();
      } catch (e){
        print(e);
        return;
      }
    }
  }
}

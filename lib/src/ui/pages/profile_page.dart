import 'dart:io';
import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/models/profile-model.dart';
import 'package:cercania/src/services/ProductService.dart';
import 'package:cercania/src/services/ProfileService.dart';
import 'package:cercania/src/services/ShopOrderService.dart';
import 'package:cercania/src/services/firebase-storage-service.dart';
import 'package:cercania/src/ui/auth/sign-in.dart';
import 'package:cercania/src/ui/auth/sign-up.dart';
import 'package:cercania/src/ui/widgets/cercania-app-bar.dart';
import 'package:cercania/src/ui/widgets/cercania-drawer.dart';
import 'package:cercania/src/ui/widgets/profile-image-picker.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'change-password_page.dart';
import 'my-oders.dart';

class ProfilePage extends StatefulWidget {
  @override
  createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _service = ShopOrderService();
  var _profileService = ProfileService();
  var _productService = ProductService();
  String pickedImage;
  bool uploading = false;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  var iosSubscription;
  @override
  void initState() {
    super.initState();
    // if (Platform.isIOS) {
    //   iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
    //     _saveDeviceToken();
    //   });
    //   _fcm.requestNotificationPermissions(IosNotificationSettings());
    // } else {
    //   _saveDeviceToken();
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (AppData.isSignedIn) {
      return Scaffold(
        drawer: CercaniaDrawer(),
        appBar: CercaniaAppBar(
          title: "Perfil",
          context: context,

        ),
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[

               !uploading ? ProfileImagePicker(
                  onImagePicked: (String image) async {
                    print(AppData.profile.id);
                    pickedImage = image;
                    setState(() {
                      uploading = true;
                    });
                   String _uploadedFileUrl = await FirebaseStorageService.uploadImage(image);
                   await FirebaseFirestore.instance
                       .collection("profiles")
                       .doc(AppData.profile.id)
                       .update({"imgUrl": _uploadedFileUrl});
                  AppData.profile.imgUrl !=null ?  await FirebaseStorageService.deleteImage(AppData.profile.imgUrl) : null;
                    AppData.profile.imgUrl = _uploadedFileUrl;
                    await AppData.profile.save();
                   setState(() {
                     uploading=false;
                   });
                  },
                  previousImage: AppData.profile?.imgUrl,
                ) : Center(
                  child: Container(
                   width: 110.0,
                   height: 110.0,
                    child: CircleAvatar(
                      backgroundImage: FileImage(File(pickedImage)),
                      child: CircularProgressIndicator(
                       backgroundColor: Colors.green,
               ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppData.profile.username,
                      style: TextStyle(fontSize: 20)),
                ),
               RaisedButton.icon(
                  icon: Icon(Icons.exit_to_app),
                  label: Text("Salir"),
                  onPressed: () async {
                   await AppData.signOut();
                    setState(() {});
                  },
                )
              ],
            ),
          ),
          // RaisedButton.icon(
          //     color: Colors.black,
          //     textColor: Colors.white,
          //     shape: StadiumBorder(),
          //     label: Text("Editar perfil"),
          //     icon: Icon(CupertinoIcons.cart),
          //     onPressed: (){}),
          RaisedButton.icon(
            color: Colors.black,
            textColor: Colors.white,
            shape: StadiumBorder(),
            label: Text("Compras realizadas"),
            icon: Icon(CupertinoIcons.cart),
              onPressed: (){
              CustomNavigator.navigateTo(context, Myorders());
              }),
          AppData.profile.password != '\$done\$' ?  RaisedButton.icon(
              color: Colors.black,
              textColor: Colors.white,
              shape: StadiumBorder(),
              label: Text("Cambia la contraseña"),
              icon: Icon(CupertinoIcons.lock),
              onPressed: (){
                CustomNavigator.navigateTo(context,ChangePassword());
              }) : SizedBox(),
        ]),
      );
    } else {
      return Scaffold(
          body: Column(children: <Widget>[
        Expanded(
            flex: 9,
            child: Center(
                child: Text("Cercania", style: TextStyle(fontSize: 30)))),
        Expanded(flex: 2, child: Container()),
        Text("Create your Account and Link with us!"),
        SizedBox(height: 10),
        Padding(
          child: ConstrainedBox(
              constraints: BoxConstraints.expand(height: 43),
              child: RaisedButton(
                  color: Colors.black,
                  child: Text("Sign up",style: TextStyle(color: Colors.white),),
                  shape: StadiumBorder(),
                  onPressed: () async {
                   await CustomNavigator.navigateTo(context, SignUpPage());
                   setState(() {

                   });
                  }
                  )),
          // CustomNavigator.navigateTo(context, ShopDetail()))),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        SizedBox(height: 30),
        Text("If you are already connected!"),
        SizedBox(height: 10),
        Padding(
          child: ConstrainedBox(
              constraints: BoxConstraints.expand(height: 43),
              child: RaisedButton(
                  color: Colors.black,
                  child: Text("Sign in",style: TextStyle(color:Colors.white),),
                  shape: StadiumBorder(),
                  onPressed: () async {
                   await CustomNavigator.navigateTo(context, SignInPage());
                   setState(() {

                   });
                  }
                     )),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        SizedBox(height: 30),
      ]));
    }
  }

  _saveDeviceToken() async {
    String fcmToken = await _fcm.getToken();
    // print("Token ::  " + fcmToken);
    if (AppData.isSignedIn) {
      if (fcmToken != null) {
        var tokenRef =
            _db.collection("profiles").doc(AppData.profile.id);
        Profile _prof = AppData.profile;
        _prof.token = fcmToken;
        _prof.platform = Platform.operatingSystem;
        AppData.signIn(_prof);
        await _profileService.setDevToken(
            AppData.profile.id, _prof.token, _prof.platform);
//        await _profileService.insertFirestore(_prof);

      }
    }
  }
}

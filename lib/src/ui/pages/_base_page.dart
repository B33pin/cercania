import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/models/profile-model.dart';
import 'package:cercania/src/services/ProfileService.dart';
import 'package:cercania/src/ui/pages/shops-list.dart';
import 'package:cercania/src/ui/widgets/notifications-dialog.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'posts.dart';
import 'home_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';


/////////////////Notifications/////////////
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//////////////////////////////////////////

class BasePage extends StatefulWidget {
  final pages = <Widget>[
    HomePage(),
    SocialMedia(),
    ShopsList(),
    FavoritesPage(),
    ProfilePage(),
  ];

  @override
  createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final _controller = CupertinoTabController();


  ///////////////////// Messaging //////////////////////////
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  var iosSubscription;
  final _profileService = ProfileService();
  /////////////////////////////////////////////////////////

  List<String> transformNotificationMessage(Map<String, dynamic> message){
    if (Platform.isAndroid) {
      return [message['notification']['title'],message['notification']['body']];
    } else if (Platform.isIOS) {
      print(message['aps']['alert']['title']);
      return [message['aps']['alert']['title'], message['aps']['alert']['body']];
    }
  }


  @override
  void initState() {
    super.initState();
    CustomNavigator.baseController = _controller;


///////////////////// Messaging //////////////////////////
  if(Platform.isIOS){ 
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data){
       _saveDeviceToken();
     });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
  }else{
    _saveDeviceToken();
  }
   _fcm.configure(
     onMessage: (Map<String, dynamic> message)async{
       print("onMessage:  $message");
       openNotificationDialog(context, transformNotificationMessage(message));
     },
          onLaunch: (Map<String, dynamic> message)async{
            openNotificationDialog(context, transformNotificationMessage(message));
            print("onLaunch:  $message");
     },
          onResume: (Map<String, dynamic> message)async{
            openNotificationDialog(context, transformNotificationMessage(message));
          }
   );


///////////////////////////////////////////////

  }

  @override
  build(context) {
    setState(() {
        if(Platform.isIOS){ 
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data){
       _saveDeviceToken();
     });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
  }else{
    _saveDeviceToken();
  }
    });
    return CupertinoTabScaffold(

      controller: _controller,
      tabBar: CupertinoTabBar(
        activeColor: Color(0xFFF24555),
        backgroundColor: CupertinoColors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              title: Text("Home"), icon: Icon(CupertinoIcons.home)),
          BottomNavigationBarItem(
              title: Text("Reseñas"), icon: Icon(Icons.supervisor_account)),
          BottomNavigationBarItem(
              title: Text("Shops"), icon: Icon(Icons.shop)),
          BottomNavigationBarItem(
              title: Text("Favoritos"),
              icon: Icon(CupertinoIcons.heart),
              activeIcon: Icon(CupertinoIcons.heart_solid)),
          BottomNavigationBarItem(
              title: Text("Perfil"),
              icon: Icon(CupertinoIcons.profile_circled)),
        ],
      ),
      tabBuilder: (BuildContext context, int index) =>
          this.widget.pages[index]);
  }



          _saveDeviceToken()async{
            String fcmToken = await _fcm.getToken();
            // print("Token ::  " + fcmToken);
            if(AppData.isSignedIn){

               if(fcmToken != null){
              var tokenRef = _db.collection("profiles").doc(AppData.profile.id);
             Profile _prof = AppData.profile;
             _prof.token = fcmToken;
             _prof.platform = Platform.operatingSystem;
             await AppData.signIn(_prof);
             await _prof.save();
              await _profileService.setDevToken(AppData.profile.id, _prof.token, _prof.platform);
            }
            }
          }
}

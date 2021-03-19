import 'dart:io';
import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/models/profile-model.dart';
import 'package:cercania/src/ui/pages/_base_page.dart';
import 'package:cercania/src/ui/widgets/loading-dialog.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:cercania/src/utils/show-snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '_Service.dart';

class ProfileService extends Service<Profile> {
  @override
  String get collectionName => "profiles";

  @override
  Profile parseModel(DocumentSnapshot document) =>
      Profile.fromJson(document.data())..id = document.id;

  Future<bool> userNameExists(String username) async {
    return (await FirebaseFirestore.instance
                .collection("profiles")
                .where("username", isEqualTo: username)
                .get()).docs.length > 0;
  }

  Future<Profile> fetchProfile(String username,
      [String password = "\$done\$"]) async {
    var docs = await FirebaseFirestore.instance
        .collection("profiles")
        .where("username", isEqualTo: username)
        .where("password", isEqualTo: password)
        .get();

    if (docs.docs.length == 0) return null;

    return parseModel(docs.docs[0]);
  }

  Future socialAuth(BuildContext context,User profile) async {

    Profile user = Profile(
          username: profile.email,
          name: profile.displayName ?? 'User',
          password: "\$done\$",
          platform: Platform.operatingSystem,
          token: await FirebaseMessaging().getToken(),
          imgUrl: profile.photoURL ?? '',
          likedProducts: [],
          likedShops: [],
    );

    openLoadingDialog(context, "Signing In");
    bool usernameExists = await userNameExists(user.username);
    if(usernameExists){
      Profile fetchedUser = await fetchProfile(user.username);
      await AppData.signIn(fetchedUser);
      Navigator.pop(context);
      CustomNavigator.pushReplacement(context, BasePage());
    }
    else {
      Profile signedInUser = await ProfileService().insertFirestore(user);
      await AppData.signIn(signedInUser);
      Navigator.pop(context);
      CustomNavigator.pushReplacement(context, BasePage());
    }
  }


  Future<String> fetchProfileDocumentId(String username) async {
    return (await FirebaseFirestore.instance.collection(collectionName).where('username',isEqualTo: username).get()).docs[0].id;
  }
  
  Future setDevToken(String profId,String token, String platform) async {
//    print(profId);
//    print(token);
//    print(platform);
    await FirebaseFirestore.instance.collection(collectionName).doc(profId).update({'platform' : platform,'token': token});
  }

  Future changePassword(BuildContext context,String oldPassword,String newPassword) async {
    openLoadingDialog(context, 'Submitting');
    bool isOldPasswordCorrect = await FirebaseFirestore.instance.collection(collectionName).
    doc(AppData.profile.id).get().then((value) {
      return value.data()['password'] == oldPassword;
    });
    if(isOldPasswordCorrect){
      await FirebaseFirestore.instance.collection(collectionName).doc(AppData.profile.id).update({
        'password' : newPassword,
      });
      AppData.profile.password = newPassword;
      await AppData.profile.save();
      Navigator.pop(context);
      showToastMsg('Password changed successfully!');
    } else {
      Navigator.pop(context);
      showToastMsg('Incorrect old password',true);
    }
  }

}

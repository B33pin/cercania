import 'dart:io';
import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/models/profile-model.dart';
import 'package:cercania/src/services/ProfileService.dart';
import 'package:cercania/src/ui/widgets/loading-dialog.dart';
import 'package:cercania/src/ui/widgets/social-auth-list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

//
class SignUpPage extends StatefulWidget {
  @override
  createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _name = TextEditingController();
  var _username = TextEditingController();
  var _password = TextEditingController();
  var _confirmPassword = TextEditingController();
  final String repImg = 'https://www.w3schools.com/howto/img_avatar.png';

  var userNameExists = false;
  final _service = ProfileService();
  bool autoValidate = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.black
          ),
        ),
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Form(
              key: _formKey,
              autovalidate: autoValidate,
              child: Column(
                children: <Widget>[
                  Text("Cercania",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(height: 50),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Display Name",
                      isDense: true,
                    ),
                    validator: (value){
                      return value.isEmpty ? 'Please enter Display Name' : null;
                    },
                    controller: _name,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Username",
                          isDense: true),
                      validator: (str) {
                        if (str.isNotEmpty) {
                          if (userNameExists) return "Username is already taken";
                        }
                        else{
                          return 'Please input username';
                        }
                        return null;
                      },
                      controller: _username,
                    ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    controller: _password,
                    validator: (value){
                      return value.isEmpty ? 'Please enter Password' : null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                        isDense: true),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                      obscureText: true,
                      controller: _confirmPassword,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Confirm Password",
                          isDense: true),
                      validator: (str) {
                        if(str.isEmpty){
                          return 'Please re-enter Password';
                        }
                        if(str != _password.text){
                          return "Passwords do not match";
                        }
                        return null;
                      },
                      ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.black,
                      textColor: Colors.white,
                        child: Text("Sign up"),
                        onPressed: () async {
                          if(_username.text.isNotEmpty) {

                            userNameExists = await _service.userNameExists(_username.text);
                            setState(() {

                            });
                          }
                          if(_formKey.currentState.validate() && !userNameExists){
                            openLoadingDialog(context, "Signing up");
                            final Profile signedUpProfile = await _service.insertFirestore(Profile(
                              name: _name.text,
                              likedProducts: [],
                              likedShops: [],
                              platform: Platform.operatingSystem,
                              token: await FirebaseMessaging().getToken(),
                              username: _username.text,
                              password: _password.text,
                            ));

                            if (signedUpProfile != null) {

                             await AppData.signIn(signedUpProfile);

                              // AppData.signIn(Profile.fromJson({
                              //   'id': a.documentID,
                              //   ...(await a.get()).data,
                              //   'likedProducts': [],
                              //   'likedShops': [],
                              //   'imgUrl': repImg,
                              // }));
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                          }

                            } else {
                            setState(() {
                              autoValidate=true;
                            });
                          }

                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Container(
                        height: 1,
                        width: double.infinity,
                        color: Color.fromRGBO(0, 0, 0, 0.1)),
                  ),
                 SocialAuthList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

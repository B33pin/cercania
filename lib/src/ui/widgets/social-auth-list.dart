
import 'dart:io';
import 'package:cercania/src/services/ProfileService.dart';
import 'package:cercania/src/utils/firebase-authentication.dart';
import 'package:flutter/material.dart';

import 'sign-in-button.dart';

class SocialAuthList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SocialAuthButton(
            color: Colors.red.shade400,
            img: 'assets/google.png',
            text: "Sign in with Google",
            onPressed: () async {
              await FirebaseAuthentication.googleAuth((user) async {
                if (user != null) {
                  await ProfileService().socialAuth(context,user);
                }
              });
            }),
        SocialAuthButton(
            color: Colors.blue.shade700,
            text: 'Sign in with Facebook',
            img: 'assets/facebook.png',
            onPressed: () async {
              await FirebaseAuthentication.facebookAuth((user) async {
                if (user != null) {
                  await ProfileService().socialAuth(context, user);
                }
              });
            }
        ),
        Platform.isIOS ? SocialAuthButton(
          text: 'Sign in with Apple',
          img: 'assets/apple.png',
          color: Colors.black,
          onPressed: () async {
            await FirebaseAuthentication.appleAuth((user) async {
              if (user != null) {
                await ProfileService().socialAuth(context, user);
              }
            });
          },
        ) : SizedBox()
        ],
    );
  }
}

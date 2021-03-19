import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthentication {
  static facebookAuth(void Function(User) onComplete ) async {
    final facebookLogin = FacebookLogin();

    final authResult = await facebookLogin.logIn(["email", "public_profile"]);

    switch (authResult.status) {
      case FacebookLoginStatus.loggedIn:
        onComplete((await FirebaseAuth.instance.signInWithCredential(FacebookAuthProvider.credential(authResult.accessToken.token))).user);
        print("Fb logged in");
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        onComplete(null);
        print("FB login error");
        break;
    }
  }

  static googleAuth(void Function(User) onComplete ) async {
    final authentication = await (await GoogleSignIn().signIn()).authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: authentication.idToken, accessToken: authentication.accessToken,
    );

    onComplete((await FirebaseAuth.instance.signInWithCredential(credential)).user);
  }

  static appleAuth(void Function(User) onComplete ) async {
    final appleIdCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oAuthProvider = OAuthProvider('apple.com');
    final credential = oAuthProvider.credential(
      idToken: appleIdCredential.identityToken,
      accessToken: appleIdCredential.authorizationCode,
    );
    onComplete((await FirebaseAuth.instance.signInWithCredential(credential)).user);
  }
}
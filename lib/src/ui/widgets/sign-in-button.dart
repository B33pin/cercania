
import 'package:flutter/material.dart';

class SocialAuthButton extends StatelessWidget {
  String text;
  Function onPressed;
  String img;
  Color color;
  SocialAuthButton({this.text,this.color, this.img,this.onPressed});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        elevation: 0,
        highlightElevation: 0,
        child: Row(children: <Widget>[
          Expanded(flex: 2, child: Image.asset(img, height: 25,color: Colors.white,)),
          Expanded(flex: 5, child: Text('${text[0].toUpperCase() + text.substring(1)}', style: TextStyle(color: Colors.white)))
        ], mainAxisAlignment: MainAxisAlignment.center),
        minWidth: double.infinity,
        color: color,
        onPressed: onPressed
    );
  }
}

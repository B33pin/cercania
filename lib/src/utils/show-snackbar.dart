import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showSimpleSnackbar(GlobalKey<ScaffoldState> key, String message,[bool error=false]){
   key.currentState.showSnackBar(SnackBar(
     backgroundColor: error? Colors.red : Colors.black,
    content: Text(message,),
     behavior: SnackBarBehavior.floating,
  ));
}

void showToastMsg(String message,[bool error=false]){
  Fluttertoast.showToast(msg: message,
      backgroundColor:error ? Colors.red :
      Color(0xfff16122),textColor: Colors.white,

  );
}
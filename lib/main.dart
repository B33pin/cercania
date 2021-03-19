import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/models/appData-model.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppData.init();
 // await LocalData.initPath();
  await Firebase.initializeApp();
  runApp(ECommerceApp());
}

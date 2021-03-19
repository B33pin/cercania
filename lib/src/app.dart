import 'package:flutter/material.dart';
import 'ui/pages/_base_page.dart';

class ECommerceApp extends MaterialApp {



  ECommerceApp(): super(
    title: "Cercania",

    theme: ThemeData(
      accentColor: Colors.black,

      appBarTheme: AppBarTheme(
        color: Colors.white,
      ),

      tabBarTheme: TabBarTheme(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey
      ),

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0)
        )
      )
    ),

    home: BasePage(),
    routes: {
      "/homePage" : (BuildContext context) => BasePage()
    }
  );
}

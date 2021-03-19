import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/ui/pages/cart-page.dart';
import 'package:cercania/src/ui/pages/search-page.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cartBadge.dart';

class CercaniaAppBar extends AppBar {
  CercaniaAppBar(
      {bool main = false,
      bool others = false,
      String title,
        bool searchBtn = false,

      BuildContext context})
      : super(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(title, style: TextStyle(color: Colors.black38)),
          actions: others
              ? []
              : <Widget>[
            searchBtn ?  Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: SizedBox(
                      height: 30,
                      width: 50,
                      child: FlatButton(
                        onPressed: () {
                          CustomNavigator.navigateTo(context, SearchPage());
                        },
                        child: Center(child: Icon(CupertinoIcons.search)),
                      ),
                    ),
                  ) : SizedBox(),
                  AppData.isSignedIn
                      ? Padding(
                          child: SizedBox(
                            width: 33,
                            height: 33,
                            child: FlatButton(
                                onPressed: () {
                                  CustomNavigator.navigateTo(
                                      context, CartPage());
                                },
                                padding: const EdgeInsets.all(0),
                                // child: Center(child: Icon(CupertinoIcons.shopping_cart)),
                                child:
                                    CartBadge(AppData.cart.length)),
                          ),
                          padding: const EdgeInsets.only(right: 10))
                      : Container(),
                ],
          backgroundColor: Colors.white,
        );
}

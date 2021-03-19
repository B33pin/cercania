import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'search-category-page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> searchTypes = ['Productos cosméticos', 'Accesorios', 'Artesanía y artes'];
  List<String> searchImages = ['assets/cosmetics.jpg', 'assets/faccessory.jpg', 'assets/artesania.jpeg'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: const EdgeInsets.all(0),
          child: Center(child: Icon(CupertinoIcons.back)),
        ),
        actions: <Widget>[
          SizedBox(
            width: 15,
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: searchTypes.length,
          itemBuilder: (context, i) {
            return Column(children: <Widget>[
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  CustomNavigator.navigateTo(context,
                      SearchCategoryPage(searchTypes[i]));
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 400,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              searchImages[i],
                              fit: BoxFit.cover,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 35.0, horizontal: 25),
                        child: Text(
                          searchTypes[i],
                          style: TextStyle(
                            color: Colors.white,
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]);
          }),
    );
  }
}

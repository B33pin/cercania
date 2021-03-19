import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/services/AdService.dart';
import 'package:cercania/src/ui/pages/search-page.dart';
import 'package:cercania/src/ui/widgets/cartBadge.dart';
import 'package:cercania/src/ui/widgets/cercania-drawer.dart';
import 'package:cercania/src/ui/widgets/product-tab-body.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cart-page.dart';

class HomePage extends StatefulWidget {
  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool isloading = true;
  TabController _controller;
  List categoryDataList = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var catdata;
  void getCategory()async{
  final categorydata = await  firestore.collection('categories').get();
  catdata = categorydata;
  categorydata.docs.forEach((element) {
    categoryDataList.add(element.data()['name']);
  });
  _controller = TabController(length: categoryDataList.length, vsync: this);
  setState(() {
    isloading = false;
  });
  }
  var _productosList = [
    "Todos",
    "Maquillaje",
    "Facial",
    "Corporal-Capilar",
    "Bipin"
  ];

  var _accesoriosCategories = [
    "Todos",
    "Anillos-Pulseras",
    "Aretes",
    "Billeteras y más",
    "Bolsos",
    "Kids",
    "Collares",
    "Relojes",
    "Lentes",
    "Mascotas",
    "Sombreros-Vinchas",
  ];

  var _artesaniaList = [
    "Todos",
    "Cerámica",
    "Confecciones",
    "Creaciones",
    "Cuadros",
  ];

  @override
  void initState() {
    getCategory();
    super.initState();
    CustomNavigator.homeController = _controller;
  }

  @override
  build(context) {
    return Scaffold(
      drawer: CercaniaDrawer(),
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: SizedBox(
                height: 30,
                width: 50,
                child: FlatButton(
                  onPressed: () =>
                      CustomNavigator.navigateTo(context, SearchPage()),
                  child: Center(child: Icon(CupertinoIcons.search)),
                ),
              ),
            ),
          ),
          Padding(
              child: SizedBox(
                width: 33,
                height: 33,
                child: FlatButton(
                  onPressed: () {
                    CustomNavigator.navigateTo(context, CartPage());
                  },
                  padding: const EdgeInsets.all(0),
                  child: CartBadge(AppData.cart.length),
                ),
              ),
              padding: const EdgeInsets.only(right: 10)),
        ],
        bottom:  PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: isloading?SizedBox():Container(
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey.shade200))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TabBar(
                controller: _controller,
                indicatorWeight: 3,
                isScrollable: true,
                labelStyle:
                    TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                labelPadding: const EdgeInsets.only(bottom: 7, top: 10),
                tabs: List.generate(categoryDataList.length, (index) => _tabBarTitles("${categoryDataList[index]}"),),
                // tabs: <Widget>[
                //   _tabBarTitles("Productos cosméticos"),
                //   _tabBarTitles("Accesorios"),
                //   _tabBarTitles("Artesanía y artes"),
                // ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: isloading?Center(child: CircularProgressIndicator()):TabBarView(
        controller: _controller,
        children: List.generate(categoryDataList.length, (index) {
          String cat = categoryDataList[index];
          print('${cat.toLowerCase().replaceAll(' ', '-')}-ads');
          return TabBody(
          adsService: ProductosService(mainproductname: '${cat.toLowerCase().replaceAll(' ', '-')}-ads'),
          categoriesList: catdata.docs[index].data()['subcat'],
          mainCategory: "${categoryDataList[index]}",
      );},),

        // children: <Widget>[
        //   TabBody(
        //       adsService: ProductosService(),
        //       categoriesList: _productosList,
        //       mainCategory: "Productos cosméticos"
        //   ),
        //   TabBody(
        //     adsService: AccesoriosService(),
        //     categoriesList: _accesoriosCategories,
        //     mainCategory: "Accesorios"
        //   ),
        //   TabBody(
        //     adsService: ArtesaniaService(),
        //     categoriesList: _artesaniaList,
        //     mainCategory: "Artesanía y artes"
        //   ),
        // ],
      ),
    );
  }

  Widget _tabBarTitles(String title){
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(title),
    );
  }
}

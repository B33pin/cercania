import 'package:cercania/src/models/Shop-model.dart';
import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/models/product-model.dart';
import 'package:cercania/src/services/ProductService.dart';
import 'package:cercania/src/services/ShopService.dart';
import 'package:cercania/src/ui/pages/search-shop_page.dart';
import 'package:cercania/src/ui/pages/shop_details.dart';
import 'package:cercania/src/ui/widgets/cercania-drawer.dart';
import 'package:cercania/src/ui/widgets/liked-shop-button.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'product_page.dart';

class ShopsList extends StatefulWidget {
  @override
  _ShopsListState createState() => _ShopsListState();
}

class _ShopsListState extends State<ShopsList> {

  final _service = ShopService();
  final _pService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Shops", style: TextStyle(color: Colors.black38)),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: SizedBox(
              height: 30,
              width: 50,
              child: FlatButton(
                onPressed: () {
                  CustomNavigator.navigateTo(context, SearchShopPage());
                },
                child: Center(child: Icon(CupertinoIcons.search)),
              ),
            ),
          )
        ],
      ),
      drawer: CercaniaDrawer(),
      body: StreamBuilder(
        stream: _service.fetchAllActiveShops(),
        builder: (context,AsyncSnapshot<List<Shop>> snapshot){
    if (snapshot.hasData) {
    switch (snapshot.connectionState) {
    case ConnectionState.none:
    return Text("No Connections");
    case ConnectionState.waiting:
    return CircularProgressIndicator();
    case ConnectionState.active:
    case ConnectionState.done:
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context,i){
              var _shop = snapshot.data[i];
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: (){
                        CustomNavigator.navigateTo(context, ShopDetail(shop: _shop));
                  },
                  splashColor: Colors.grey.shade200,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("${i+1}",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left:8.0,top: 12),
                                    child: Text(_shop.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                                    overflow: TextOverflow.ellipsis,  ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left:8.0),
                                    child: Text(_shop.tagLine,style: TextStyle(color: Colors.grey.shade500,),overflow: TextOverflow.ellipsis,),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            _shop.isForHandicapped ? Image.asset("assets/is-for-handicapped.png",scale: 7,): SizedBox(),
                            AppData.isSignedIn
                                ? LikeShopButton(
                                AppData.canLikeShop(_shop.id),
                               _shop.id,
                                    )
                                : Container(),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:20.0,left: 15),
                          child: StreamBuilder(
                              stream: _pService.fetchAllShop(_shop.username),
                              builder: (context, AsyncSnapshot<List<Products>> snapshot){
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return SizedBox();
                                  case ConnectionState.active:
                                  default:
                                    break;
                                }
                                if (snapshot.hasError) print(snapshot.error);

                                var productsLength = snapshot.data?.length ?? 0;

                                return productsLength > 0 ?SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    itemCount: productsLength,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context,i){
                                      var _shopImage = snapshot.data[i].images[0].url;
                                      return Padding(
                                        padding: const EdgeInsets.only(right:8.0),
                                        child: _shopImage!=""? Image.network(_shopImage,fit: BoxFit.cover,) : SizedBox(),
                                      );
                                    },
                                  ),
                                ): SizedBox();
                            },
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ),
              );
            },

          );
      default:
        break;
    }
    }
    return Text("");
        },
      ),
    );
  }
}

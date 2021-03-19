import 'package:cercania/src/models/Shop-model.dart';
import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/models/product-model.dart';
import 'package:cercania/src/services/ProductService.dart';
import 'package:cercania/src/services/ShopService.dart';
import 'package:cercania/src/ui/auth/sign-in.dart';
import 'package:cercania/src/ui/widgets/cercania-app-bar.dart';
import 'package:cercania/src/ui/widgets/cercania-drawer.dart';
import 'package:cercania/src/ui/widgets/liked-shop-button.dart';
import 'package:cercania/src/ui/widgets/shopable-item.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'product_page.dart';
import 'shop_details.dart';

class FavoritesPage extends StatefulWidget {
  @override
  createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with SingleTickerProviderStateMixin {
  var _canShow = false;
  var _products = <Products>[];
  var _shops = <Shop>[];
  final _productService = ProductService();
  final _shopService = ShopService();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);

    _productService.fetchFavoritesFirestore().then((products) {
      setState(() {
        this._canShow = true;
        this._products = products;
        print("Fetched favorited products:  $_products");
      });
    });

    _shopService.fetchFavoritesFirestore().then((shops) {
      setState(() {
        this._canShow = true;
        this._shops = shops;
        print("Fetched favorited shops:  $_shops");
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CercaniaDrawer(),
        appBar: CercaniaAppBar(context: context, title: 'Favoritos'),

        body: !AppData.isSignedIn
            ? Center(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              Text("You are not signed in"),
              RaisedButton(
                child: Text("Sign In !"),
                onPressed: () {
                  CustomNavigator.navigateTo(context, SignInPage());
                },
              )
          ],
        ),
            ): Column(
          children: <Widget>[
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.refresh),
                SizedBox(
                  width: 20,
                ),
                Text("Deslizar hacia abajo para Actualizar")
              ],
            ),
            TabBar(
              labelColor: Colors.red,
              tabs: [
                Tab(icon: Row(
                  children: <Widget>[
                    Icon(Icons.favorite),
                    Text("Productos favoritos"),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                )),
                Tab(
                  icon: Row(
                    children: <Widget>[
                      Icon(Icons.favorite),
                      Text("Shops favoritos"),
                    ],
                  ),
                ),
              ],
              controller: _tabController,
            ),
            Expanded(
              child: TabBarView(
                children: [
                    (this._canShow
                          ? RefreshIndicator(
                          key: GlobalKey<RefreshIndicatorState>(),
                          onRefresh: () async {
                            var prod =
                            await _productService.fetchFavoritesFirestore();
                            setState(() => this._products = prod);
                          },
                          child: CustomScrollView(slivers: <Widget>[

                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                              sliver: SliverGrid(
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.6),
                                delegate: SliverChildBuilderDelegate(
                                        (context, i) => ShopableItem(this._products[i],
                                        onFavChanged: () => setState(() {})),
                                    childCount: this._products.length),
                              ),
                            ) ,
                          ]))
                          : Center(child: CircularProgressIndicator()
                   )
                   ),
                   (this._canShow
                   ? RefreshIndicator(
                   key: GlobalKey<RefreshIndicatorState>(),
                   onRefresh: () async {
                   var shops =
                   await _shopService.fetchFavoritesFirestore();
                   setState(() => this._shops = shops);
                   },
                   child:  ListView.builder(
                              itemCount: _shops.length,
                              itemBuilder: (context,i){
                                var _shop = _shops[i];
                                return     Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: InkWell(
                                    onTap: (){
                                      CustomNavigator.navigateTo(context, ShopDetail(shop: _shop));
                                    },
                                    splashColor: Colors.grey.shade200,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text("${i+1}",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(left:8.0,top: 12),
                                                    child: Text(_shop.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left:8.0),
                                                    child: Text(_shop.tagLine,style: TextStyle(color: Colors.grey.shade500),
                                                      overflow: TextOverflow.ellipsis,),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(child: Container(),),
                                            AppData.isSignedIn
                                                ? LikeShopButton(
                                                AppData.canLikeShop(_shop.id),_shop.id
                                                    )
                                                : Container(),
                                          ],
                                        ),

                                        Divider(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )   )     : Center(child: CircularProgressIndicator()
    )
    ),


                ],
                controller: _tabController,
              ),
            ),
            SizedBox(height: 10),


          ],
        ));
  }
}








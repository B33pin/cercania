import 'package:cercania/src/models/Shop-model.dart';
import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/models/product-model.dart';
import 'package:cercania/src/services/ProductService.dart';
import 'package:cercania/src/services/ShopService.dart';
import 'package:cercania/src/ui/pages/shop_details.dart';
import 'package:cercania/src/ui/widgets/liked-shop-button.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SearchShopPage extends StatefulWidget {
  @override
  _SearchShopPageState createState() => _SearchShopPageState();
}

class _SearchShopPageState extends State<SearchShopPage> {
  String error;
  List<Shop> _shops = [];
  List<Shop> _filtered = [];

  final _service = ShopService();
  final _search = TextEditingController();
  final _pService = ProductService();

  @override
  void initState() {
    super.initState();

    _service.fetchAllActiveShops().listen((event) {
      setState(() {
        this.error = null;

        this._shops = event;
        this._filtered = this
            ._shops
            .where((shop) =>
            shop.name.toLowerCase().contains(_search.text.toLowerCase()))
            .toList();
      });
    }, onError: (error) {
      setState(() {
        this.error = error.toString();
      });
      print("Error Occurred in stream: " + error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            titleSpacing: 0,
            leading: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              padding: const EdgeInsets.all(0),
              child: Center(child: Icon(CupertinoIcons.back)),
            ),
            actions: <Widget>[SizedBox(width: 15)],
            title: CupertinoTextField(
              controller: _search,
              cursorColor: Colors.grey,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8)),
              placeholder: "Search Shop...",
              clearButtonMode: OverlayVisibilityMode.editing,
              prefix: Padding(
                padding: const EdgeInsets.fromLTRB(8, 7, 2, 8),
                child: Icon(CupertinoIcons.search,
                    size: 18, color: Colors.grey.shade700),
              ),
              onChanged: (value) {
                print(value);
                setState(() {
                  this._filtered = this
                      ._shops
                      .where((shop) => shop.name
                      .toLowerCase()
                      .contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
            backgroundColor: Colors.white,
          ),

          this.error == null
              ? SliverPadding(
            padding: const EdgeInsets.all(5),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        var _shop = this._filtered[i];
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
                                        if (snapshot.hasError) print(snapshot.error.toString());
                                        var productsLength = snapshot.data.length;
                                        print("Products Length : ${snapshot.data.length}");
                                        return snapshot.data.length != 0 ?SizedBox(
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
                  childCount: this._filtered.length),
            ),
          )
              : Text(this.error)
          // StreamBuilder(
          //     stream:
          //         _searchService.fetchAllCategoryFirestore(widget.searchType),
          //     builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          //       if (snapshot.hasData) {
          //         switch (snapshot.connectionState) {
          //           case ConnectionState.none:
          //             return SliverToBoxAdapter(
          //               child: Text("Error"),
          //             );
          //           case ConnectionState.waiting:
          //             return SliverToBoxAdapter(
          //               child: Center(child: CircularProgressIndicator()),
          //             );
          //           case ConnectionState.active:
          //           case ConnectionState.done:
          //           default:
          //             break;
          //         }

          //         var filteredData = snapshot.data
          //             .where((shop) => shop.name
          //                 .toLowerCase()
          //                 .contains(searchController.text.toLowerCase()))
          //             .toList();

          //         return SliverPadding(
          //           padding: const EdgeInsets.all(5),
          //           sliver: SliverGrid(
          //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //                 crossAxisCount: 2, childAspectRatio: .6),
          //             delegate: SliverChildBuilderDelegate(
          //                 (context, i) => ShopableItem(filteredData[i]),
          //                 childCount: filteredData.length),
          //           ),
          //         );
          //       } else {
          //         return SliverToBoxAdapter(
          //           child: Text(snapshot.toString()),
          //         );
          //       }
          //     })
        ],
      ),
    );
  }
}

import 'package:cercania/src/models/Shop-model.dart';
import 'package:cercania/src/models/product-model.dart';
import 'package:cercania/src/services/ProductService.dart';
import 'package:cercania/src/ui/pages/shop-Info.dart';
import 'package:cercania/src/ui/widgets/shopable-item.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
class ShopDetail extends StatefulWidget {
  //final ProductService service = ProductService();
  final Shop shop;
  ShopDetail({this.shop});
  @override
  createState() => _HomePageTabHotState();
}

class _HomePageTabHotState extends State<ShopDetail>
     {
       final ProductService service = ProductService();

       // List<Tab> tabList = List();

  // TabController _tabController;

  // void initState() {
  //   tabList.add(Tab(text: "Products"));
  //   tabList.add(Tab(text: "Shop Info"));
  //   _tabController = new TabController(vsync: this, length: tabList.length);
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  @override
  build(context) => Scaffold(
        appBar: AppBar(
          title: Text(
            widget.shop.name,
            style: TextStyle(color: Colors.black45),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(150.0)),
                      ),
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(150.0)),
                          child: widget.shop.image!=null ? Image.network(widget.shop.image.url,  fit: BoxFit.cover): CircleAvatar()
                      )
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  widget.shop.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                  child: Text(
                    widget.shop.tagLine,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 15,),
                RaisedButton(
                  child: Text(
                      "Shop Info"),
                  color: Colors.black12,
                  onPressed: (){
                    CustomNavigator.navigateTo(context, ShopInfo(widget.shop.contact,widget.shop.email,widget.shop.address)
                );},),
                SizedBox(
                  height: 25,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Store Products",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      Divider(
                        color: Colors.black,
                        indent: 160,
                        endIndent: 160,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
  StreamBuilder(
  stream: service.fetchAllShop(widget.shop.username),
  builder: (BuildContext context,
      AsyncSnapshot<List<Products>> snapshots) {
  switch (snapshots.connectionState) {
  case ConnectionState.waiting:
  return SliverList(
  delegate: SliverChildListDelegate.fixed([Text("")]),
  );
  case ConnectionState.active:
  default:
  break;
  }

  if (snapshots.hasError)
  return SliverList(
  delegate: SliverChildListDelegate.fixed([Text("")]),
  );

  return SliverPadding(
  padding: const EdgeInsets.all(5),
  sliver: SliverGrid(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2, childAspectRatio: .6),
  delegate: SliverChildBuilderDelegate(
  (context, i) => ShopableItem(snapshots.data[i]),
  childCount: snapshots.data.length),
  ),
  );
  }),
          
          // SliverToBoxAdapter(
          //   child: Column(children: <Widget>[
          //     TabBar(controller: _tabController, tabs: tabList),
          //     TabBarView(
                
          //         controller: _tabController,
          //         children: tabList.map((Tab tab) {
          //           _getPage(tab);
          //         }).toList())
          //   ]),
          // ),
          //  SliverToBoxAdapter(
          //     child: TabBarView(
          //         controller: controller,
          //         children: <Widget>[ShopProducts(), ShopProducts()]))
        ]),
      );

  // Widget _getPage(Tab tab) {
  //   switch (tab.text) {
  //     case 'Products':
  //       return ShopProducts();
  //     case 'Shop Info':
  //       return ShopProducts();
  //   }
  // }
}

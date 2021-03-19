import 'package:cercania/src/models/product-model.dart';
import 'package:cercania/src/services/ProductService.dart';
import 'package:cercania/src/services/_Service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'ads-widget.dart';
import 'shopable-item.dart';
import 'simple-stream-buider.dart';

class TabBody extends StatefulWidget {
  final List categoriesList;
  final Service adsService;
  final String mainCategory;

  TabBody({this.categoriesList,this.mainCategory,this.adsService});
  @override
  _TabBodyState createState() => _TabBodyState();
}

class _TabBodyState extends State<TabBody> with SingleTickerProviderStateMixin {

  TabController _controller;
  @override
  void initState() {
    super.initState();
    this._controller = TabController(length: widget.categoriesList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
   return Column(
      children: <Widget>[
        Container(
          height: 55,
          decoration: BoxDecoration(
              color: Colors.white,
              border:
              Border(bottom: BorderSide(color: Colors.grey.shade200))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TabBar(
                controller: this._controller,
                isScrollable: true,
                labelColor: Colors.white,
                indicator: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50)),
                unselectedLabelColor: Colors.grey,
                tabs: widget.categoriesList.map((t) => Tab(child: Text(t))).toList()),
          ),
        ),
        Expanded(
          child: TabBarView(
              controller: this._controller,
              physics: NeverScrollableScrollPhysics(),
              children:
              this.widget.categoriesList.map((t) => _Body(
                mainCategory: widget.mainCategory,
                categoriesList: widget.categoriesList,
                adsService: widget.adsService,
                subCategory: t,
              )).toList()),
        ),

      ],
    );

  }

}

class _Body extends StatefulWidget {
  final List categoriesList;
  final Service adsService;
  final String mainCategory;
  final String subCategory;
  _Body({this.categoriesList,this.mainCategory,this.adsService,this.subCategory});
  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  int selected = 1;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
       widget.subCategory!="Todos"?SliverToBoxAdapter(child: Container(),):SliverToBoxAdapter(
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: selected==1?true:false,onChanged: (value){
                          setState(() {
                            selected=1;
                          });
                        }),
                        Text("Price ↑")
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(value: selected==2?true:false,onChanged: (v){
                          setState(() {
                            selected=2;
                          });
                        }),
                        Text("Price ↓")
                      ],
                    ), Row(
                      children: [
                        Checkbox(value: selected==3?true:false,onChanged: (v){
                          setState(() {
                            selected=3;
                          });
                        }),
                        Text("Ratings ↑")
                      ],
                    )
                  ],
                )
            ),
          ),
        ),
        AdsWidget(
          service:widget.adsService,
          currentCategory: widget.subCategory,
        ),

        SimpleStreamBuilder<List<Products>>.simplerSliver(
            context: context,
            stream: selected==1?ProductService()
                .fetchAllSubCategoryFirestoreOrderPriceDessending(
                widget.mainCategory, widget.subCategory):selected==2?ProductService()
                .fetchAllSubCategoryFirestoreOrderPriceAssending(
                widget.mainCategory, widget.subCategory):ProductService()
                .fetchAllSubCategoryFirestoreOrderRating(
                widget.mainCategory, widget.subCategory),
            builder: (List<Products> snapshot) {
              return SliverPadding(
                padding: const EdgeInsets.all(5),
                sliver: SliverGrid(
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .6),
                  delegate: SliverChildBuilderDelegate(
                          (context, i) =>
                          ShopableItem(snapshot[i]),
                      childCount: snapshot.length),
                ),
              );
            }),
      ],
    );
  }
}



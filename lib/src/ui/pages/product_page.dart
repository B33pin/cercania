
import 'package:cercania/src/models/Shop-model.dart';
import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/models/cart-product-model.dart';
import 'package:cercania/src/models/product-model.dart';
import 'package:cercania/src/services/ProductService.dart';
import 'package:cercania/src/services/ShopService.dart';
import 'package:cercania/src/ui/auth/sign-in.dart';
import 'package:cercania/src/ui/pages/view_ratings.dart';
import 'package:cercania/src/ui/widgets/cercania-app-bar.dart';
import 'package:cercania/src/ui/widgets/liked-prduct-button.dart';
import 'package:cercania/src/ui/widgets/liked-shop-button.dart';
import 'package:cercania/src/ui/widgets/simple-future-builder.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'cart-page.dart';
import 'dart:core';
import 'shop_details.dart';

class ProductPage extends StatefulWidget {
  final Products product;
  final ProductService service = ProductService();

  ProductPage(this.product);

  @override
  createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  var _productService = ProductService();
  var _shopService = ShopService();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CercaniaAppBar(context: context, title: this.widget.product.name),
      body: Stack(children: <Widget>[
          CustomScrollView(slivers: <Widget>[
            SliverToBoxAdapter(
                child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: PageView.builder(
                        itemCount: widget.product.images.length,
                        itemBuilder: (context, i) => Container(
                              constraints: BoxConstraints.expand(),
                              child: widget.product.images.isNotEmpty
                                  ? Image.network(widget.product.images[i].url,
                                      fit: BoxFit.cover)
                                  : Image.asset("assets/no-image-placeholder.jpg",
                                      fit: BoxFit.cover),
                            )))),
            SliverToBoxAdapter(
                child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: SimpleFutureBuilder<Shop>.simpler(
                context: context,
                future: _shopService.fetchShopName(this.widget.product.shopId),
                builder: (AsyncSnapshot<Shop> snapshot) {
                  return InkWell(
                        splashColor: Colors.grey.shade200,
                        onTap: (){
                          CustomNavigator.navigateTo(context, ShopDetail(shop: snapshot.data,));
                        } ,
                        child: Row(
                            children: <Widget>[
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: snapshot.data.image == null
                                      ? CircleAvatar()
                                      : Image.network(snapshot.data.image.url),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(snapshot.data.name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey.shade500)),
                              Expanded(child: Container(),),
                             AppData.isSignedIn ? LikeShopButton(
                               AppData.canLikeShop(snapshot.data.id),snapshot.data.id
                             ) : Container()
                            ]),
                      );
                  }

              ),
            )),
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: (){
                  print(widget.product.id);
                  showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => viewRatings(shop_id: widget.product.id,),
                  );
                },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          widget.product.ratings.toInt()==0?Text('🌟'):widget.product.ratings.toInt()==1?Text('🌟'):widget.product.ratings.toInt()==2?Text('🌟🌟'):widget.product.ratings.toInt()==3?Text('🌟🌟🌟'):widget.product.ratings.toInt()==4?Text('🌟🌟🌟🌟'):Text('🌟🌟🌟🌟🌟')
                          ,
                          SizedBox(width: 20,),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        child: Text(' ${widget.product.ratings}  Total Ratings',style: TextStyle(fontWeight: FontWeight.w500),),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80,left: 10,right: 10),
                    child: Text(widget.product.detail),
                  ),
                ],
              ),
            )
          ]),
          Align(
            alignment: Alignment(1, 1),
            child: Container(
              height: 80,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.grey.shade400, blurRadius: 3)
              ]),
              child: Row(children: <Widget>[
                Expanded(
                    child: GestureDetector(
                        child: Container(
                          child: Center(
                              child: Column(children: <Widget>[
                                AppData.isSignedIn? LikeButton(
                                  AppData.canLikeProduct(widget.product.id),widget.product.id
                                ):Container()
                          ], mainAxisAlignment: MainAxisAlignment.center)),
                        ),
                        onTap: () {}),
                    flex: 2),
                Expanded(
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                              child: Text("¡A Comprar!",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20))),
                        ),
                      ),
                      onTap: ()=> addProductToCart(context)
                      // this.addProductToCart(context),
                    ),
                    flex: 6),
              ]),
            ),
          )
        ]),
    );
  }
  //
  void addProductToCart(context) {
    if (AppData.isSignedIn) {
      if (AppData.canAddToCart(widget.product.id)) {
        setState(() {
          AppData.addToCart(CartProduct(
            product: widget.product,
          ));
        });
        scaffoldKey.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          content: Text("Producto añadido a su carrito."),
        ));
      } else {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          content: Text(
              "Product is already added to cart.\nClick the cart button to view added products."),
          action: SnackBarAction(
              label: "Su carrito",
              onPressed: () async {
                await CustomNavigator.navigateTo(context, CartPage());
                setState(() {});
              }),
        ));
      }
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 3),
          content: Text("Sign In to proceed further."),
          action: SnackBarAction(
              label: "SignIn",
              textColor: Colors.white,
              onPressed: () =>
                  CustomNavigator.navigateTo(context, SignInPage()))));
    }
  }


}




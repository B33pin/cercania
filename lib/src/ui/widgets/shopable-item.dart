import 'dart:async';
import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/models/product-model.dart';
import 'package:cercania/src/ui/pages/product_page.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:flutter/material.dart';

import 'liked-prduct-button.dart';

class ShopableItem extends StatefulWidget {
  final Products product;
  final void Function() onFavChanged;

  ShopableItem(this.product, {this.onFavChanged});

  @override
  createState() => _ShopableItemState();
}

class _ShopableItemState extends State<ShopableItem>
    with SingleTickerProviderStateMixin {
  int _pos = 0;
  Timer _timer;

  @override
  void initState() {
    shuffleImage();
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => shuffleImage());
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer = null;

    super.dispose();
  }

  void shuffleImage() {
    if (widget.product.images.length > 0 && this.mounted) {
      setState(() {
        _pos = (_pos + 1) % widget.product.images.length;
      });
    }
  }

  @override
  build(context) =>  InkWell(
        onTap: () => CustomNavigator.navigateTo(
            context, ProductPage(this.widget.product)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 165,
                    width: 165,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: widget.product.images.length > 0
                          ? Image.network(
                        widget.product.images[_pos].url,
                              gaplessPlayback: true,
                              fit: BoxFit.cover,
                            ): Image.asset("assets/no-image-placeholder.jpg"),
                    ),
                  ),
                  SizedBox(
                      width: 165,
                      child: Text(this.widget.product.name,
                          overflow: TextOverflow.ellipsis)),
                  SizedBox(
                      width: 165,
                      height: 20,
                      child: Text(this.widget.product.detail,
                          overflow: TextOverflow.ellipsis)),
                  Row(
                    children: <Widget>[
                      this.widget.product.discount != 0
                          ? Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                  this
                                          .widget
                                          .product
                                          .discount
                                          .toInt()
                                          .toString() +
                                      "%",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Lato',
                                      color: Colors.red)))
                          : Container(),
                      Text(
                          this.widget.product.price + "Gs",
                          style: TextStyle(fontSize: 16, fontFamily: 'Lato'))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child:
                        Text(this.widget.product.ratings.toString() + " Total Ratings"),
                  )
                ],
              ),
             AppData.isSignedIn
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: LikeButton(
                          AppData.canLikeProduct(widget.product.id),
                          this.widget.product.id,
                      //    this.widget.onFavChanged
                      ))
                  : Container(),
            ],
          ),
        ),
      );
}


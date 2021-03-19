import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartBadge extends StatefulWidget {
  int count;
  CartBadge(this.count);
  @override
  State<StatefulWidget> createState() {
    return CartBadgeState();
  }
}

class CartBadgeState extends State<CartBadge> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(children: <Widget>[
      Icon(CupertinoIcons.shopping_cart),
      Positioned(
          left: 0,
          child: (widget.count == 0)
              ? Container()
              : Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6)),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(widget.count.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center),
                ))
    ]));
  }
}

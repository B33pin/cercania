import 'package:cercania/src/models/product-model.dart';
import 'package:cercania/src/services/ProductService.dart';
import 'package:cercania/src/ui/widgets/shopable-item.dart';
import 'package:flutter/material.dart';

class ShopProducts extends StatefulWidget{
    final ProductService service = ProductService();

  @override
  State<StatefulWidget> createState() {
    return ShopProductsState();
  }
}

class ShopProductsState extends State<ShopProducts>{
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
              stream: widget.service.fetchAllDealType('Hot'),
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
              });
  }

}
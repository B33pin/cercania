import 'package:cercania/src/models/product-model.dart';
import 'package:cercania/src/services/ProductService.dart';
import 'package:cercania/src/ui/widgets/shopable-item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SearchCategoryPage extends StatefulWidget {
  final String searchType;

  SearchCategoryPage(this.searchType);

  @override
  _SearchCategoryPageState createState() => _SearchCategoryPageState();
}

class _SearchCategoryPageState extends State<SearchCategoryPage> {
  String error;
  List<Products> _products = [];
  List<Products> _filtered = [];

  final _service = ProductService();
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();

    _service.fetchAllCategoryFirestore(widget.searchType).listen((event) {
      setState(() {
        this.error = null;

        this._products = event;
        this._filtered = this
            ._products
            .where((product) =>
                product.name.toLowerCase().contains(_search.text.toLowerCase()))
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
              placeholder: "Search ${widget.searchType}...",
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
                      ._products
                      .where((product) => product.name
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
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: .6),
                    delegate: SliverChildBuilderDelegate(
                        (context, i) => ShopableItem(this._filtered[i]),
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
          //             .where((product) => product.name
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

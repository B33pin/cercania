import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/ui/pages/place-order-page.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _selectionMode = false;
  List<int> _selectedIndexes = [];

  _getTotal(){
    var sum = 0.0;
    AppData.cart.forEach((element) {
      sum+=element.product.dbPrice * element.quantity;
    });
    return sum.toString();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.grey),
              onPressed: () {
                if (this._selectionMode == true)
                  setState(() => this._selectionMode = false);
                else
                  Navigator.pop(context);
              },
            ),
            title: Text("Cart", style: TextStyle(color: Colors.grey)),),
        body: AppData.cart.isNotEmpty
            ? ListView.builder(
                itemCount: AppData.cart.length,
                itemBuilder: (context, i) {
                  var c = AppData.cart[i];

                return Stack(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(color: Colors.grey.shade400)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              children: <Widget>[
                                Container(
                                  width: 70,
                                  height: 70,
                                  child:  c.product.images != null?
                                  Image.network(c.product.images[0].url
                                  ):Image.asset("assets/no-image-placeholder.jpg"),
                                ),
                                SizedBox(width: 10),
                                Expanded(child: Column(
                                  children: <Widget>[
                                    Text(c.product.name, style: TextStyle(
                                      fontSize: 17,
                                    ),maxLines: 2,),
                                    Text("${c.quantity} x  ${c.product.price} ", style: TextStyle(color: Colors.red)),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                )),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      MaterialButton(
                                        shape: CircleBorder(),
                                        minWidth: 0,
                                        padding: EdgeInsets.only(right: 10),
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        onPressed: () => setState(() {
                                          if (c.quantity > 1)
                                            --c.quantity;
                                        }),
                                        child: Icon(Icons.remove_circle),
                                      ),
                                      Text(c.quantity.toString()),
                                      MaterialButton(
                                        padding: EdgeInsets.only(left: 10),
                                        shape: CircleBorder(),
                                        child: Icon(Icons.add_circle),
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        onPressed: () => setState(() {
                                          ++c.quantity;
                                        }),
                                        minWidth: 0,
                                      ),
                                    ],mainAxisSize: MainAxisSize.min,

                                      mainAxisAlignment: MainAxisAlignment.end,
                                    ),

                                    SizedBox(
                                      child: GestureDetector(
                                        onTap: () async {
                                         await c.delete(); setState(() {});
                                        },
                                        child:Text("Remove",style: TextStyle(color: Colors.primaries[0]),),

                                      ),
                                    )
                                  ],
                                )

                              ]),

                        )
                    ),
                  ),
                ]);

                })
            : Center(
                child: Text(
                  "Cart is empty. \n Add products to cart to proceed further.",
                  textAlign: TextAlign.center,
                ),
              ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: Row(children: [

            Text("Total :",style: TextStyle(fontSize: 18,color:Colors.black,fontWeight: FontWeight.bold),),
            Text(_getTotal(),style: TextStyle(fontSize: 18,),),SizedBox(width: 10,),

            Expanded(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)
                ),

                  color: Colors.black,
                  child: Text("Place Order",style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    goToCheckOutPage();
                  }),
            )

          ],),
        ),
      ),


    );
  }

  void goToCheckOutPage() async {
    await CustomNavigator.navigateTo(context, PlaceOrder());
  }
}

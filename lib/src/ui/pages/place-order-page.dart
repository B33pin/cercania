import 'package:cercania/src/models/ShopOrder-model.dart';
import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/services/ProfileService.dart';
import 'package:cercania/src/services/ShopOrderService.dart';
import 'package:cercania/src/services/ShopService.dart';
import 'package:cercania/src/ui/widgets/loading-dialog.dart';
import 'package:cercania/src/utils/custom-navigator.dart';
import 'package:cercania/src/utils/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '_base_page.dart';

class PlaceOrder extends StatefulWidget {

  PlaceOrder();

  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  final phoneController = TextEditingController();

  final addressController = TextEditingController();
  final ruc = TextEditingController();
  final businessName = TextEditingController();

  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

   bool taxInfo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.grey),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Proceed to Checkout", style: TextStyle(color: Colors.grey)),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 40, 10.0, 0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: this.phoneController,
                    keyboardType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value)=>emptyValidator(value, "Teléfono"),
                    decoration: InputDecoration(
                        labelText: "Teléfono", border: OutlineInputBorder()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value)=>emptyValidator(value, "Dirección"),
                      controller: this.addressController,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Dirección", border: OutlineInputBorder()),
                    ),
                  ),
                  CheckboxListTile(
                    dense: true,
                    title: Text("Solicitar factura"),
                    value: taxInfo,
                    activeColor: Colors.blue,
                    checkColor: Colors.white,
                    onChanged: (bool val){
                      setState(() {
                        taxInfo=val;
                      });
                    },

                  ),
                   taxInfo ? Column(children: <Widget>[
                       Padding(
                         padding: const EdgeInsets.only(top: 10.0),
                         child: TextFormField(
                           controller: this.ruc,
                           maxLines: null,
                           decoration: InputDecoration(
                               labelText: "RUC", border: OutlineInputBorder()),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 20.0),
                         child: TextFormField(
                           controller: this.businessName,
                           maxLines: null,
                           decoration: InputDecoration(
                               labelText: "Razón Social", border: OutlineInputBorder()),
                         ),
                       ),
                     ],
                   ) : SizedBox(),



                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.done),
          ),
          Text("Finalizar compra")
        ]),
        onPressed: () async {
          if(formKey.currentState.validate()){
            checkOutProcessing(context);
          }
        },
      ),
    );
  }

  void checkOutProcessing(context) async {
    openLoadingDialog(context, "Placing order");

    var service = ShopOrderService();
    var _shopService = ShopService();

    for (var prod in AppData.cart) {

      int _shopCommission = 0;
     await _shopService.fetchShopName(prod.product.shopId).then((shop){
       _shopCommission=shop.commission;
      });

     var _price = (prod.product.dbPrice - (prod.product.dbPrice * (prod.product.discount/100)  )) * prod.quantity;

     var _commission = _shopCommission!= 0 ? (_price * _shopCommission) / 100 : 0;

      service.insertFirestore(ShopOrder(
          userId: AppData.profile.id,
          username: AppData.profile.name,
          phone: this.phoneController.text,
          address: this.addressController.text,
          time: Timestamp.now(),
          productId: prod.product.id,
          name: prod.product.name,
          price:  _price,
          commission: _commission.toString(),
          quantity: prod.quantity,
          shopId: prod.product.shopId,
          status: "Just Ordered",
          businessName: taxInfo ? businessName.text :'',
          ruc:  taxInfo ? ruc.text : ''
      ));

      var prof = AppData.profile;
      AppData.likeProduct(prod.product.id);
      prof.save();
      await ProfileService().updateFirestore(prof);
      await AppData.signIn(prof);
    }

    Navigator.pop(context);

    await _scaffoldkey.currentState
        .showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Compra realizada."),
        ))
        .closed;

    AppData.clearCart();

    CustomNavigator.pushReplacement(context, BasePage());

    // CustomNavigator.navigateToHome();
  }
}

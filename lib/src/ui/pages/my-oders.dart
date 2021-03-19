import 'package:cercania/src/models/ShopOrder-model.dart';
import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/services/ShopOrderService.dart';
import 'package:cercania/src/ui/pages/writeReview.dart';
import 'package:cercania/src/ui/widgets/simple-stream-buider.dart';
import 'package:cercania/src/utils/date-formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Myorders extends StatefulWidget {
  @override
  _MyordersState createState() => _MyordersState();
}

class _MyordersState extends State<Myorders> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: ()=> Navigator.pop(context),
        ),
        title: Text("Compras realizadas",style: TextStyle(
          color: Colors.black
        ),),
        centerTitle: true,
      ),
      body: SimpleStreamBuilder.simpler(
        stream: ShopOrderService().fetchOrders(AppData.profile.id),
        context: context,
        builder: (List<ShopOrder> order){
          print('got here');
          print(AppData.profile.id);
          return ListView.builder(
              shrinkWrap: true,
              itemCount: order.length,
              itemBuilder: (context, i) =>
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(elevation: 10,
                      color: Colors.white70,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Row(children: [
                                      Text("Fecha de compra: ", style: TextStyle(
                                              color: Colors.black
                                          )
                                      ),
                                      Text( ((DateTime date) =>
                                      "${date.hour % 12}:${date.minute} ${date.hour > 12 ? 'PM' : 'AM'} ${getFormattedDate(order[i].time.toDate().toString())}")(
                                        order[i].time.toDate(),),
                                        style: TextStyle(color: Colors.blue),)],),
                                  SizedBox(height: 5),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Estado de compras: ",style: TextStyle(color: Colors.black), ),
                                      Text(order[i].status,style: TextStyle(color: Colors.blue),)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(order[i].name),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.credit_card,
                                        color: Colors.black),
                                    Text(" Precio:"),
                                    SizedBox(width: 5),
                                    Text(order[i].price
                                        .toString(),style: TextStyle(color: Colors.blue),),
                                    Text(
                                      " Gs.",
                                      style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold),
                                    )
                                  ],
                                ),
                                FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: (){
                                    showCupertinoModalBottomSheet(
                                      context: context,
                                      builder: (context) => writeReview(productname: order[i].productId,id: AppData.profile.id,),
                                    );
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.green
                                    ),
                                    child: Center(child: Text('Feedback',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                  ),
                                )
                              ],
                            ),  ],
                        ),
                      ),
                    ),
                  )

              );
        },
      )
    );
  }
}

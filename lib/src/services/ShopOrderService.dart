import 'package:cercania/src/models/ShopOrder-model.dart';
import 'package:cercania/src/services/_Service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopOrderService extends Service<ShopOrder> {
  @override
  String get collectionName => "shop-orders";

  @override
  ShopOrder parseModel(DocumentSnapshot document) {
    return ShopOrder.fromJson(document.data())..id = document.id;
  }

  Stream<List<ShopOrder>> fetchOrders(String userId) {
    var resp = FirebaseFirestore.instance.collection(collectionName).orderBy("time",descending: true)
        .where('userId',isEqualTo: userId)
        .snapshots().map((snapshot) => snapshot.docs.map((document) => parseModel(document)).toList());

    return resp;
  }

}
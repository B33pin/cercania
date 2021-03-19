import 'dart:developer';

import 'package:cercania/src/models/Order-model.dart';
import 'package:cercania/src/models/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class OrderService extends Service {
  @override
  String get collectionName => "orders";

  @override
  Model parseModel(DocumentSnapshot document) {
    return Order.fromJson(document.data())..id = document.id;
  }


}
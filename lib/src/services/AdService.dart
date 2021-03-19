import 'package:cercania/src/models/Ad-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '_Service.dart';

class ProductosService extends Service<Ad> {
  ProductosService({@required this.mainproductname});
  String mainproductname;
  @override
  String get collectionName => mainproductname;
  @override
  Ad parseModel(DocumentSnapshot document) {
    return Ad.fromJson(document.data())..id = document.id;
  }

}
class AccesoriosService extends Service<Ad> {
  @override
  String get collectionName => "accessories-ads";

  @override
  Ad parseModel(DocumentSnapshot document) {
    return Ad.fromJson(document.data())..id = document.id;
  }

}
class ArtesaniaService extends Service<Ad> {
  @override
  String get collectionName => "artesanía-y-artes-ads";

  @override
  Ad parseModel(DocumentSnapshot document) {
    return Ad.fromJson(document.data())..id = document.id;
  }

}
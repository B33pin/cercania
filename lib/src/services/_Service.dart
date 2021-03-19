import 'package:cercania/src/models/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Service<T extends Model> {
  String get collectionName;

  T parseModel(DocumentSnapshot document);

  Stream<List<T>> fetchAllFirestore() => FirebaseFirestore.instance.collection(collectionName)
    .snapshots().map((snapshot) => snapshot.docs.map((document) => parseModel(document)).toList());

  Stream<List<T>> fetchAllSortedFirestore() => FirebaseFirestore.instance.collection(collectionName).orderBy("time",descending: true)
    .snapshots().map((snapshot) => snapshot.docs.map((document) => parseModel(document)).toList());

  Future<T> fetchOneFirestore(String id) async =>
    parseModel(await FirebaseFirestore.instance.collection(collectionName).doc(id).get());


  insertFirestore(T model) async {
    try {
      // print(model.toJson());
      final a =await FirebaseFirestore.instance.collection(collectionName).add(model.toJson());
      return parseModel(await a.get());
    } catch (e) {
      print(e);
      return null;
    }
  }

  updateFirestore(T model) async {
    return await FirebaseFirestore.instance.collection(collectionName).doc(model.id).set(model.toJson());
  }
}
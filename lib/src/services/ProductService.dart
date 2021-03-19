import 'package:cercania/src/models/appData-model.dart';
import 'package:cercania/src/models/product-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProfileService.dart';
import '_Service.dart';

class ProductService extends Service<Products> {
  @override
  String get collectionName => "products";

  @override
  Products parseModel(DocumentSnapshot document) {
    if (document.data == null) {
      AppData.likedProducts.remove(document.id);
      AppData.profile.save();
      ProfileService().updateFirestore(AppData.profile);
      return null;
    } else {
      return Products.fromJson(document.data())..id = document.id;
    }

  }

  Future<List<Products>> fetchFavoritesFirestore() async {
    final list = <Products>[];
    if (AppData.isSignedIn) {
      for (String id in AppData.likedProducts){
        final item = await this.fetchOneFirestore(id);
        if(item!=null){
          list.add(await this.fetchOneFirestore(id));
        }
        print(id);
      }
    }

    return list;
  }
  Stream<List<Products>> fetchAllCategoryFirestorePricingOrderDescending(String category) => FirebaseFirestore.instance.collection(collectionName)
      .orderBy('price',descending: true)
      .where("category", isEqualTo: category)
      .where("disabled",isEqualTo: false)
      .snapshots().map((snapshot) => snapshot.docs.map((document) => parseModel(document)).toList());

  Stream<List<Products>> fetchAllCategoryFirestorePricingOrderAscending(String category) => FirebaseFirestore.instance.collection(collectionName)
      .orderBy('price')
      .where("category", isEqualTo: category)
      .where("disabled",isEqualTo: false)
      .snapshots().map((snapshot) => snapshot.docs.map((document) => parseModel(document)).toList());

  Stream<List<Products>> fetchAllCategoryFirestoreRatings(String category) => FirebaseFirestore.instance.collection(collectionName)
      .orderBy('ratings',descending: true)
      .where("category", isEqualTo: category)
      .where("disabled",isEqualTo: false)
      .snapshots().map((snapshot) => snapshot.docs.map((document) => parseModel(document)).toList());

  Stream<List<Products>> fetchAllCategoryFirestore(String category) => FirebaseFirestore.instance.collection(collectionName)
      .where("category", isEqualTo: category)
      .where("disabled",isEqualTo: false)
      .snapshots().map((snapshot) => snapshot.docs.map((document) => parseModel(document)).toList());

  Stream<List<Products>> fetchAllSubCategoryFirestore(String category, String subCategory) {
    print(category + " | " + subCategory);
    if (subCategory == 'Todos') return this.fetchAllCategoryFirestore(category);

    return FirebaseFirestore.instance
        .collection(collectionName)
        .where('category', isEqualTo: category).orderBy('price')
        .where("disabled",isEqualTo: false)
        .where('product-type', isEqualTo: subCategory)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => parseModel(document))
            .toList());
  }
  Stream<List<Products>> fetchAllSubCategoryFirestoreOrderPriceAssending(String category, String subCategory) {
    print(category + " | " + subCategory);
    if (subCategory == 'Todos') return this.fetchAllCategoryFirestorePricingOrderAscending(category);

    return FirebaseFirestore.instance
        .collection(collectionName)
        .where('category', isEqualTo: category)
        .where("disabled",isEqualTo: false)
        .where('product-type', isEqualTo: subCategory)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((document) => parseModel(document))
        .toList());
  }
  Stream<List<Products>> fetchAllSubCategoryFirestoreOrderPriceDessending(String category, String subCategory) {
    print(category + " | " + subCategory);
    if (subCategory == 'Todos') return this.fetchAllCategoryFirestorePricingOrderDescending(category);

    return FirebaseFirestore.instance
        .collection(collectionName)
        .where('category', isEqualTo: category)
        .where("disabled",isEqualTo: false)
        .where('product-type', isEqualTo: subCategory)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((document) => parseModel(document))
        .toList());
  }
  Stream<List<Products>> fetchAllSubCategoryFirestoreOrderRating(String category, String subCategory) {
    print(category + " | " + subCategory);
    if (subCategory == 'Todos') return this.fetchAllCategoryFirestoreRatings(category);

    return FirebaseFirestore.instance
        .collection(collectionName)
        .where('category', isEqualTo: category)
        .where("disabled",isEqualTo: false)
        .where('product-type', isEqualTo: subCategory)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((document) => parseModel(document))
        .toList());
  }
  Stream<List<Products>> fetchAllDealType(String dealType) {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .where('deal-type', isEqualTo: dealType)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => parseModel(document))
            .toList());
  }

  Stream<List<Products>> fetchAllShop(String shopId) {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .where('shopId', isEqualTo: shopId)
        .where("disabled",isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => parseModel(document))
            .toList());
  }

}

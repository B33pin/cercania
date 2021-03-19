import 'package:cercania/src/models/Shop-model.dart';
import 'package:cercania/src/models/appData-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProfileService.dart';
import '_Service.dart';

class ShopService extends Service<Shop> {
  @override
  String get collectionName => "shops";

  @override
  Shop parseModel(DocumentSnapshot document) {
    if (document.data == null) {
      AppData.profile.likedShops.remove(document.id);
      AppData.profile.save();
      ProfileService().updateFirestore(AppData.profile);
      return null;
    } else {
      return Shop.fromJson(document.data())..id = document.id;
    }

  }

  Future<Shop> fetchShopName(String shopUsername) async =>
      parseModel((await FirebaseFirestore.instance.collection(collectionName).where('username',isEqualTo: shopUsername).get()).docs[0]);

  Future<List<Shop>> fetchFavoritesFirestore() async {
    final list = <Shop>[];
    if (AppData.isSignedIn) {
      for (String id in AppData.profile.likedShops){
        final item = await this.fetchOneFirestore(id);
        print("Shop $item");
        if(item!=null){
          list.add(await this.fetchOneFirestore(id));
        }
      }
    }
    return list;
  }

  Stream<List<Shop>> fetchAllActiveShops() {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .where("disabled",isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((document) => parseModel(document))
        .toList());
  }

}
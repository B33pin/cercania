// import 'dart:io';
// import 'dart:convert';
// import 'package:ecommerce/src/models/cart-product-model.dart';
// import 'package:ecommerce/src/models/profile-model.dart';
// import 'package:path_provider/path_provider.dart';
// class LocalData {
//   static File _dataFile;
//   static Profile _profile;
//   static bool _signedIn = false;
//   static List<CartProduct> addedProducts = [];
//   static Profile getProfile() {
//     return _profile;
//   }
//   static void setProfile(Profile profile) {
//     _signedIn = profile != null;
//     _profile = profile;
//     writeData();
//   }
//   static void writeData() {
//     if (_profile != null) {
//       if (_profile.likedProducts == null) _profile.likedProducts = [];
//       if (_profile.likedShops == null) _profile.likedShops = [];
//       _dataFile.writeAsString(jsonEncode(_profile.toJson()));
//     }
//     _dataFile.writeAsString(jsonEncode(_profile));
//   }
//   static void readData() {}
//   static isSignedIn() => _signedIn;
//   static initPath() async {
//     var dir = await getApplicationDocumentsDirectory();
//     _dataFile = File(dir.path + "/data.json");
//     try {
//       await _dataFile.create();
//     } catch (ex) {
//       print(ex);
//     }
//     try {
//       Map<String, dynamic> data = jsonDecode(await _dataFile.readAsString());
//       _profile = Profile.fromJson(data);
//       _signedIn = true;
//     } catch (ex) {
//       _signedIn = false;
//     }
//   }
//   // init() {
//   // bestTabsController = TabController(length: 12, vsync: LocalData.bestTab);
//   // }
// }
//
// // class CartProduct {
// //   Product product;
// //   int quantity = 0;
// //
// //   @override
// //   bool operator ==(other) {
// //     if (other is CartProduct)
// //       return this.product == other.product;
// //     else
// //       return this == other;
// //   }
// // }

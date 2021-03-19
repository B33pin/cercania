import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'cart-product-model.dart';
import 'image-model.dart';
import 'product-model.dart';
import 'profile-model.dart';

class AppData {
  static Box<Profile> _profile;
  static Box<CartProduct> _cart;

  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProfileAdapter());
    Hive.registerAdapter(ImageModelAdapter());
    Hive.registerAdapter(CartProductAdapter());
    Hive.registerAdapter(ProductsAdapter());
    // _clearData();
    _profile = await Hive.openBox('profile');
    _cart = await Hive.openBox('cart');

    print("Profile: ${_profile.values.map((e) => e.toJson())}");
  }

  //only for testing
  static void _clearData() async {
    await Hive.deleteBoxFromDisk('profile');
  }

  static Future signIn(Profile user) async {
    await _profile?.clear();
    await _profile?.add(user);
    await user.save();
  }

  static bool get isSignedIn => _profile.values.isNotEmpty;

  static Profile get profile => _profile.values?.first;

  static List<CartProduct> get cart => _cart.values.toList() ?? [];

  static List<String> get likedProducts => profile.likedProducts ?? [];

  static Future signOut() async {
    await FacebookLogin().logOut();
    await GoogleSignIn().signOut();
    await _profile.clear();
  }

  static bool canLikeProduct(String productId) => !profile.likedProducts.contains(productId);

  static bool canLikeShop(String shopId) => !profile.likedShops.contains(shopId);


  static Future likeProduct(String productId) async {
    if(canLikeProduct(productId))
      profile.likedProducts.add(productId);
    else
      profile.likedProducts.remove(productId);
    await profile.save();
  }

  static Future likeShop(String shopId) async {
    if(canLikeShop(shopId))
        profile.likedShops.add(shopId);
    else
      profile.likedShops.remove(shopId);
     await profile.save();
  }

  static bool canAddToCart(String productId){
    for(var prod in _cart.values){
      if(prod.product.id == productId)
        return false;
    }
    return true;
  }

  static addToCart(CartProduct cartProduct)async {
   await _cart.add(cartProduct);
    cartProduct.save();
  }

  static clearCart() async
  {
   await _cart.clear();
  }

}


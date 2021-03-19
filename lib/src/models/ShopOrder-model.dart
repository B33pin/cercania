import 'package:cloud_firestore/cloud_firestore.dart';

import 'model.dart';

class ShopOrder extends Model {
  String username;
  String userId;
  String phone;
  String address;
  Timestamp time;
  int quantity;
  double price;
  String productId;
  String shopId;
  String status;
  String name;
  String ruc;
  String businessName;
  String commission;


  ShopOrder({
    this.phone,
    this.userId,
    this.address,
    this.username,
    this.time,
    this.price,
    this.name,
    this.status,
    this.commission,
    this.productId,
    this.shopId,
    this.quantity,this.businessName,this.ruc
  }): super();

  @override
  Map<String, dynamic> toJson() => {
    "phone": this.phone,
    "userId": this.userId,
    "address": this.address,
    "username": this.username,
    "commission": this.commission,
    "time": this.time,
    "quantity": this.quantity,
    "shopId": this.shopId,
    "productId": this.productId,
    "status": this.status,
    "name": this.name,
    "price": this.price,
    "ruc": this.ruc,
    "business-name": this.businessName,
  };

  ShopOrder.fromJson(Map<String, dynamic> json): this(
    phone: json["phone"],
    userId: json["userId"],
    address: json["address"],
    username: json["username"],
    time: json["time"],
    quantity: json["quantity"],
    shopId: json["shopId"],
    commission: json["commission"],
    productId: json["productId"],
    status: json["status"],
    name: json["name"],
    ruc: json["ruc"],
    businessName: json["business-name"],
    price: double.parse(json["price"].toString()),
  );
}

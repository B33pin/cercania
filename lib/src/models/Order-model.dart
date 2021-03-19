import 'model.dart';

class Order extends Model {
  double price;
  String phone;
  String userId;
  String address;
  List<String> shopIds;
  List<String> productIds;

  Order({
    String id,
    this.price,
    this.phone,
    this.userId,
    this.address,
    this.shopIds,
    this.productIds
  }): super(id: id);

  @override
  Map<String, dynamic> toJson() => {
    "userIds": this.userId,
    "price": this.price,
    "phone": this.phone,
    "address": this.address,
    "shopIds": this.shopIds,
    "productIds": this.productIds
  };

  Order.fromJson(Map<String, dynamic> json): this(
    price: json["price"],
    phone: json["phone"],
    address: json["address"],
    userId: json["userId"],
    shopIds: (json["shopIds"] as List).map((e) => e.toString()).toList(),
    productIds: (json["productIds"] as List).map((e) => e.toString()).toList()
  );
}
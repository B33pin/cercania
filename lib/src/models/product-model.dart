
import 'image-model.dart';
import 'model.dart';
import 'package:hive/hive.dart';

part 'product-model.g.dart';

@HiveType(typeId: 2)
class Products extends HiveObject implements Model {
  @HiveField(1)
  int likes;
  @HiveField(2)
  double dbPrice;
  @HiveField(3)
  double discount;
  @HiveField(4)
  String name;
  @HiveField(5)
  String detail;
  @HiveField(6)
  String shopId;
  @HiveField(7)
  List<ImageModel> images;
  @HiveField(8)
  bool disabled;
  @HiveField(9)
  double ratings;
  String get price => dbPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');



  Products({
    String id,
    this.likes,
    this.dbPrice,
    this.name,
    this.detail,
    this.disabled,
    this.shopId,
    this.discount,
    this.images,
    this.ratings
  });

  @override
  Map<String, dynamic> toJson() => {
    "likes": this.likes,
    "name": this.name,
    "price": this.dbPrice,
    "detail": this.detail,
    "discount": this.discount,
    "shopId": this.shopId,
    "disabled" : this.disabled,
    "images": this.images.map((image) => image.toJson()).toList(),
    "ratings": this.ratings
  };

  Products.fromJson(Map<String, dynamic> json)
      : this(
    id: json["id"].toString(),
    disabled: json["disabled"],
    ratings:json["ratings"]==null?0:json["ratings"],
    name: json["name"].toString(),
    likes: json["likes"] == null || json["discount"] == ''
        ? 0
        : int.parse(json["likes"].toString()),
    discount: json["discount"] == null || json["discount"] == ''
        ? 0
        : double.parse(json["discount"].toString()),
    dbPrice: json["price"] == null || json["price"] == ''
        ? 0
        : double.parse(json["price"].toString()),
    detail: json["detail"] == null ? "" : json["detail"].toString(),
    shopId: json["shopId"].toString(),
    images: (json['images'] as List)
        ?.map((i) => ImageModel.fromJson(i))
        ?.toList(),
  );

  @HiveField(0)
  @override String id;
}


import 'image-model.dart';
import 'model.dart';

class Shop extends Model {
  String name;
  ImageModel image;
  int subscribers;
  String username;
  String email;
  String contact;
  String tagLine;
  int commission;
  String address;
  bool isForHandicapped;


  Shop({
    String id,
    this.name,
    this.image,
    this.subscribers,
    this.username,
    this.email,
    this.contact,
    this.tagLine,
    this.commission,
    this.address,
    this.isForHandicapped
  }): super(id: id);

  @override
  Map<String, dynamic> toJson() => {
    "name": this.name,
    "image": this.image,
    "subscribers": this.subscribers,
    "username": this.username,
    "email": this.email,
    "commission" : this.commission,
    "contact": this.contact,
    "tag-line": this.tagLine,
    "address": this.address,
    "is-for-handicapped": this.isForHandicapped
  };

  Shop.fromJson(Map<String, dynamic> json): this(
    id: json["id"],
    name: json["name"],
    commission: int.parse(json["commission"].toString()),
    image: json['image'] !=null ? ImageModel.fromJson(json['image']) : null,
    subscribers: json["subscribers"],
    username: json["username"],
    email: json["email"],
    contact: json["contact"],
    tagLine: json["tag-line"],
    address: json["address"],
    isForHandicapped: json["is-for-handicapped"] !=null ? json["is-for-handicapped"] : false,
  );
}

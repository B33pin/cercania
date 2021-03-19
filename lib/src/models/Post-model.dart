import 'package:cloud_firestore/cloud_firestore.dart';

import 'model.dart';

class Post extends Model {
  int likes;
  String userId;
  String name;
  String userImage;
  String shopId;
  String description;
  List<String> images;
  Timestamp time;

  Post({
    String id,
    this.likes,
    this.userId,
    this.shopId,
    this.images,
    this.name,
    this.description,
    this.userImage,
    this.time
  }): super(id: id);

  @override
  Map<String, dynamic> toJson() => {
    "likes": this.likes,
    "userId": this.userId,
    "userImage": this.userImage,
    "shopId": this.shopId,
    "description": this.description,
    "images": this.images,
    "name": this.name,
    "time": this.time,
  };

  Post.fromJson(Map<String, dynamic> json): this(
    id: json["id"],
    userId: json["userId"],
    shopId: json["shopId"],
    description: json["description"] ?? '',
    images:  (json['images'] as List).map((e) => e.toString()).toList(),
    name: json["name"] ?? '',
    userImage: json["userImage"],
    likes: json["likes"] ?? 0,
    time: json["time"]
  );
}
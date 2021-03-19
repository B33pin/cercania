import 'package:hive/hive.dart';

import 'model.dart';
part 'profile-model.g.dart';

@HiveType(typeId: 0)
class Profile extends HiveObject implements Model {
  @HiveField(0)
  String name;
  @HiveField(1)
  String imgUrl;
  @HiveField(2)
  String username;
  @HiveField(3)
  String password;
  @HiveField(4)
  String token;
  @HiveField(5)
  String platform;
  @HiveField(6)
  List<String> likedShops = [];
  @HiveField(7)
  List<String> likedProducts = [];

  Profile({
    String id = '',
    this.name = '',
    this.imgUrl = '',
    this.username = '',
    this.password = '',
    this.likedProducts = const [],
    this.token = '',
    this.platform = '',
    this.likedShops = const []
  });

  @override
  Map<String, dynamic> toJson() => {
    "id": this.id,
    "name": this.name,
    "imgUrl": this.imgUrl,
    "username": this.username,
    "password": this.password,
    "likedProducts": this.likedProducts,
    "token": this.token,
    "platform": this.platform,
    "likedShops": this.likedShops
  };

  Profile.fromJson(Map<String, dynamic> json): this(
    id: json["id"],
    name: json["name"],
    imgUrl: json["imgUrl"],
    username: json["username"],
    password: json["password"],
    platform: json["platform"],
    token: json["token"],
    likedProducts: json["likedProducts"] != null?
    (json["likedProducts"] as List).map((pr) => pr.toString()).toList(): <String>[],
    likedShops: json["likedShops"] != null?
    (json["likedShops"] as List).map((pr) => pr.toString()).toList(): <String>[],
  );

  @override
  @HiveField(8)
  String id;
}

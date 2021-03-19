import 'package:hive/hive.dart';
part 'image-model.g.dart';

@HiveType(typeId: 3)
class ImageModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String url;

  ImageModel(this.name, this.url);

  Map<String, dynamic> toJson() => {
    "name": this.name,
    "url": this.url
  };

  ImageModel.fromJson(Map jsonMap)
      : name = jsonMap['name'].toString(),
        url = jsonMap['url'];
}
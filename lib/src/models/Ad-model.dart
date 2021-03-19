import 'model.dart';


class Ad extends Model {
  String name;
  String url;

  Ad({
    String id,
    this.name,
    this.url,
  }): super(id: id);

  @override
  Map<String, dynamic> toJson() => {
    "name": this.name,
    "url": this.url,
  };

  Ad.fromJson(Map<String, dynamic> json): this(
    id: json["id"].toString(),
    name: json["name"].toString(),
    url: json["url"],
  );
}

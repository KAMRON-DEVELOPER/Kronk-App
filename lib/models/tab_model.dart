import 'package:hive/hive.dart';

class MyTab extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;

  MyTab({
    this.id,
    this.name,
  });

  factory MyTab.fromJson(json) {
    return MyTab(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, String> toJson() {
    return {'name': name ?? ''};
  }

  MyTab forUpdate(MyTab? tab) {
    return MyTab(
      name: tab?.name ?? name,
    );
  }
}

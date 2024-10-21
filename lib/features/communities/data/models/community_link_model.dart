class CommunityLinkModel {
  CommunityLinkModel({
    this.name,
    this.value,
    this.id,
  });

  String? name;
  String? value;
  final dynamic id;

  factory CommunityLinkModel.fromJson(Map<String, dynamic> json) => CommunityLinkModel(
    name: json["name"],
    value: json["value"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
    "id": id,
  };
}
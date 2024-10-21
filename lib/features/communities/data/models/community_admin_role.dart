
class CommunityAdminRoleModel {
  int? id;
  int? communityId;
  String? name;
  String? color;
  int? isDefault;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? permissions;

  CommunityAdminRoleModel({
    this.id,
    this.communityId,
    this.name,
    this.color,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
    this.permissions,
  });

  factory CommunityAdminRoleModel.fromJson(Map<String, dynamic> json) => CommunityAdminRoleModel(
    id: json["id"],
    communityId: json["communityId"].runtimeType == int ? json["communityId"] : (json["communityId"] == null ? null : int.parse(json["communityId"])),
    name: json["name"],
    color: json["color"],
    isDefault: json["isDefault"].runtimeType == int ? json["isDefault"] : (json["isDefault"] == "true" ? 1 : 0),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    permissions: json["permissions"] == null ? [] : List<String>.from(json["permissions"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "communityId": communityId,
    "name": name,
    "color": color,
    "isDefault": isDefault,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x)),
  };
}

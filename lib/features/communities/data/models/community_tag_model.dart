

// part 'community_tag_model.g.dart';

//@JsonSerializable(explicitToJson: true)
// class CommunityTagModel {
//   const CommunityTagModel({
//     this.id,
//     this.tagDescription,
//     this.communityId,
//     this.tagId,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   final int? id;
//   final int? communityId;
//   final int? tagId;
//   final String? tagDescription;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   factory CommunityTagModel.fromJson(Map<String, dynamic> json) => _$CommunityTagModelFromJson(json);
//   Map<String, dynamic> toJson() => _$CommunityTagModelToJson(this);
//
// }

class CommunityTagModel {
  final int? id;
  final String? tagDescription;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CommunityTag? communityTag;

  CommunityTagModel({
    this.id,
    this.tagDescription,
    this.createdAt,
    this.updatedAt,
    this.communityTag,
  });

  factory CommunityTagModel.fromJson(Map<String, dynamic> json) => CommunityTagModel(
    id: json["id"],
    tagDescription: json["tagDescription"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    communityTag: json["community_tag"] == null ? null : CommunityTag.fromJson(json["community_tag"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tagDescription": tagDescription,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "community_tag": communityTag?.toJson(),
  };
}

class CommunityTag {
  final int? id;
  final int? communityId;
  final int? tagId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CommunityTag({
    this.id,
    this.communityId,
    this.tagId,
    this.createdAt,
    this.updatedAt,
  });

  factory CommunityTag.fromJson(Map<String, dynamic> json) => CommunityTag(
    id: json["id"],
    communityId: json["communityId"],
    tagId: json["tagId"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "communityId": communityId,
    "tagId": tagId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

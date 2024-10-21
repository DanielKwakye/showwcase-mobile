
import 'package:showwcase_v3/features/communities/data/models/community_category_model.dart';

class UpdateCommunitiesModel {
  CommunityCategoryModel? category;
  String? about;
  String? name;
  String? description;
  String? pictureKey;
  String? pictureKeyRemote;
  String? coverImageKey;
  String? coverImageKeyRemote;
  List<dynamic>? socials;
  int? categoryId;

  UpdateCommunitiesModel({
    this.category,
    this.about,
    this.name,
    this.description,
    this.pictureKey,
    this.pictureKeyRemote,
    this.coverImageKey,
    this.coverImageKeyRemote,
    this.socials,
    this.categoryId,
  });

  factory UpdateCommunitiesModel.fromJson(Map<String, dynamic> json) => UpdateCommunitiesModel(
    category: json["category"] ,
    about: json["about"],
    name: json["name"],
    description: json["description"],
    pictureKey: json["pictureKey"],
    pictureKeyRemote: json["pictureKey_remote"],
    coverImageKey: json["coverImageKey"],
    coverImageKeyRemote: json["coverImageKey_remote"],
    socials: json["socials"] == null ? [] : List<dynamic>.from(json["socials"]!.map((x) => x)),
    categoryId: json["categoryId"],
  );

  Map<String, dynamic> toJson() => {
    "category": category?.toJson(),
    "about": about,
    "name": name,
    "description": description,
    "pictureKey": pictureKey,
    "pictureKey_remote": pictureKeyRemote,
    "coverImageKey": coverImageKey,
    "coverImageKey_remote": coverImageKeyRemote,
    "socials": socials == null ? [] : List<dynamic>.from(socials!.map((x) => x)),
    "categoryId": categoryId,
  };
}
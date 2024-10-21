import 'package:showwcase_v3/features/communities/data/models/community_category_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_link_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_role_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_settings_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_tag_model.dart';


class CommunityUpdateWelcomeScreen {
  CommunityUpdateWelcomeScreen({
    this.id,
    this.userId,
    this.categoryId,
    this.name,
    this.slug,
    this.description,
    this.about,
    this.isApproved,
    this.pictureKey,
    this.coverImageKey,
    this.welcomeScreen,
    this.enableWelcomeScreen,
    this.lastActivity,
    this.totalMembers,
    this.createdAt,
    this.tags,
    this.settings,
    this.category,
    this.isFeatured,
    this.communityRole,
    this.isMember,
    this.isPinned,
    this.hasNewContent,
    this.isStale,
    this.communityPermissions,
    this.interests,
    this.socials,
  }) : super();

  int? id;
  int? userId;
  int? categoryId;
  String? name;
  String? slug;
  String? description;
  String? about;
  bool? isApproved;
  String? pictureKey;
  String? coverImageKey;
  String? welcomeScreen;
  bool? enableWelcomeScreen;
  dynamic lastActivity;
  int? totalMembers;
  DateTime? createdAt;
  List<CommunityTagModel>? tags;
  CommunitySettingsModel? settings;
  CommunityCategoryModel? category;
  bool? isFeatured;
  bool? isStale;
  bool? isPinned;
  CommunityRoleModel? communityRole;
  bool? isMember;
  List<String>? communityPermissions;
  bool? hasNewContent;
  List<String>? interests;
  List<CommunityLinkModel>? socials;

  factory CommunityUpdateWelcomeScreen.fromJson(Map<String, dynamic> json) => CommunityUpdateWelcomeScreen(
    id: json["id"],
    userId: json["userId"],
    categoryId: json["categoryId"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    about: json["about"],
    isApproved: json["isApproved"],
    pictureKey: json["pictureKey"],
    coverImageKey: json["coverImageKey"],
    welcomeScreen: json["welcomeScreen"],
    enableWelcomeScreen: json["enableWelcomeScreen"],
    lastActivity: json["lastActivity"],
    totalMembers: json["totalMembers"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    socials: json["socials"] == null ? [] : List<CommunityLinkModel>.from(json["socials"]!.map((x) => CommunityLinkModel.fromJson(x))),
    tags: json["tags"] == null ? null : List<CommunityTagModel>.from(json["tags"].map((x) => x)),
    settings: json["settings"],
    category: json["category"],
    isPinned: json["isPinned"],
    isFeatured: json["isFeatured"],
    communityRole: json["communityRole"],
    communityPermissions: json["communityPermissions"] == null ? null : List<String>.from(json["communityPermissions"].map((x) => x)),
    isMember: json["isMember"],
    isStale: json["isStale"],
    hasNewContent: json["hasNewContent"],
    interests: json["interests"] == null ? [] : List<String>.from(json["interests"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "categoryId": categoryId,
    "name": name,
    "slug": slug,
    "description": description,
    "about": about,
    "isApproved": isApproved,
    "pictureKey": pictureKey,
    "coverImageKey": coverImageKey,
    "welcomeScreen": welcomeScreen,
    "enableWelcomeScreen": enableWelcomeScreen,
    "lastActivity": lastActivity,
    "totalMembers": totalMembers,
    "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
    "tags": tags == null ? null : List<dynamic>.from(tags!.map((x) => x.toJson())),
    "socials": socials == null ? [] : List<dynamic>.from(socials!.map((x) => x.toJson())),
    "settings": settings == null ? null : settings!.toJson(),
    "category": category == null ? null : category!.toJson(),
    if(communityRole != null) "communityRole": communityRole == null ? null : communityRole!.toJson(),
    "communityPermissions": communityPermissions == null ? null : List<dynamic>.from(communityPermissions!.map((x) => x)),
  if(isMember != null) "isMember": isMember ,
    if(isFeatured != null)  "isFeatured": isFeatured,
    if(hasNewContent != null)  "hasNewContent": hasNewContent,
    if(isStale != null)  "isStale": isStale,
    if(isPinned != null) "isPinned": isPinned,
    "interests": interests == null ? [] : List<dynamic>.from(interests!.map((x) => x)),
  };
}
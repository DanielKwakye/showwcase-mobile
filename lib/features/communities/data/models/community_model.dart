import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/communities/data/models/community_category_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_link_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_role_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_settings_model.dart';
import 'package:showwcase_v3/features/communities/data/models/community_tag_model.dart';

part 'community_model.g.dart';

@JsonSerializable()
@CopyWith()
class CommunityModel extends Equatable {
  final int? id;
  final int? userId;
  final int? categoryId;
  final String? name;
  final String? slug;
  final String? description;
  final String? about;
  final bool? isApproved;
  final String? pictureKey;
  final String? pictureUrl;
  final String? coverImageUrl;
  final String? coverImageKey;
  final String? welcomeScreen;
  final bool? enableWelcomeScreen;
  final dynamic lastActivity;
  final int? totalMembers;
  final DateTime? createdAt;
  final List<CommunityTagModel>? tags;
  final CommunitySettingsModel? settings;
  final CommunityCategoryModel? category;
  final bool? isFeatured;
  final bool? isStale;
  final bool? isPinned;
  final CommunityRoleModel? communityRole;
  final bool? isMember;
  final List<String>? communityPermissions;
  final bool? hasNewContent;
  final List<CommunityLinkModel>? socials;
  final List<String>? interests;

  const CommunityModel({
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
    this.pictureUrl,
    this.coverImageUrl,
    this.socials,
    this.interests,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityModelToJson(this);

  @override
  List<Object?> get props => [id, isMember, totalMembers, isApproved, isPinned, communityPermissions, communityRole, isFeatured];
}

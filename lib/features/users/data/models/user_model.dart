import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/communities/data/models/community_role_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_activity_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_custom_domain_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_details_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_engagement_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_settings_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_tag_model.dart';

part 'user_model.g.dart';

@HiveType(typeId: kUserModelHive)
@JsonSerializable(explicitToJson: true)
@CopyWith()
class UserModel extends Equatable {

    final int? id;
    final String? email;

    @JsonKey(
        fromJson: _activityFromJson
    )
    final UserActivityModel? activity;
    final int? userId;

     @HiveField(1)
    final String? displayName;

     @HiveField(0)
    final String? username;

    final String? language;
    final List<String>? languages;
    final String? githubProfile;
    final String? headline;
    final String? location;
    final String? about;
    final String? role;
    final dynamic ban;

     @HiveField(2)
    final String? profilePictureKey;

    final String? profileCoverImageKey;
    final int? totalWorkedWiths;
    final int? totalThreads;
    final int? totalProjects;
    final int? totalInvited;
    final String? domain;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final UserCustomDomainModel? customDomain;
    final List<String>? badges;
    final List<UserTagModel>? tags;
    final List<String>? interests;
    final int? totalFollowers;
    final int? totalFollowing;
    final bool? isCreator;
    final bool? isOnline;
    final String? isOpenToConnect;
    final bool? onboarded;
    final UserDetailsModel? details;
    final EngagementModel? engagement;

    // is followed is set to basic if you're following this user
    final dynamic isFollowed;
    final dynamic isColleague;

    // this is when the user is following you
    final bool? isFollowing;

    final bool? isBlocked;
    final bool? hasBlocked;

    final UserSettingsModel? settings;

    @JsonKey(fromJson: _lastNotificationReadFromJson)
    final DateTime? lastNotificationRead;
    final String? resumeUrl;
    final String? theme;

    static UserActivityModel? _activityFromJson(dynamic value) =>
        value == null ? null : ((value is String) ? UserActivityModel.fromJson(json.decode(value)) : UserActivityModel.fromJson(value));

    static DateTime? _lastNotificationReadFromJson(dynamic value) {
        return value == null ? null : value is String ? DateTime.parse(value)
        : value is int ? DateTime.fromMillisecondsSinceEpoch(value * 1000) : null;
    }
    final bool? isOwner;
    final dynamic isAdmin;
    final List<String>? communityPermissions;
    final CommunityRoleModel? communityRole;
    final String? referralToken;

    const UserModel({
        this.activity,
        this.id,
        this.email,
        this.userId,
        this.displayName,
        this.username,
        this.language,
        this.languages,
        this.githubProfile,
        this.headline,
        this.location,
        this.about,
        this.role,
        this.ban,
        this.details,
        this.profilePictureKey,
        this.profileCoverImageKey,
        this.totalWorkedWiths,
        this.totalThreads,
        this.totalProjects,
        this.totalInvited,
        this.domain,
        this.createdAt,
        this.updatedAt,
        this.customDomain,
        this.badges,
        this.tags,
        this.totalFollowers,
        this.totalFollowing,
        this.isCreator,
        this.isOnline,
        this.isOpenToConnect,
        this.isFollowed,
        this.isColleague,
        this.isFollowing,
        this.isBlocked,
        this.hasBlocked,
        this.onboarded,
        this.settings,
        this.lastNotificationRead,
        this.resumeUrl,
        this.theme,
        this.isOwner,
        this.isAdmin,
        this.communityPermissions,
        this.communityRole,
        this.referralToken,
        this.engagement,
        this.interests
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
    Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [username, tags, languages, about, isFollowing, isFollowed, isBlocked, hasBlocked, totalFollowers, totalFollowing, details, onboarded,isOwner, isAdmin, communityPermissions, communityRole, referralToken, engagement, lastNotificationRead, theme, settings, interests, isColleague, isOpenToConnect, isOnline];

}
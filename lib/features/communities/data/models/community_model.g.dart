// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CommunityModelCWProxy {
  CommunityModel id(int? id);

  CommunityModel userId(int? userId);

  CommunityModel categoryId(int? categoryId);

  CommunityModel name(String? name);

  CommunityModel slug(String? slug);

  CommunityModel description(String? description);

  CommunityModel about(String? about);

  CommunityModel isApproved(bool? isApproved);

  CommunityModel pictureKey(String? pictureKey);

  CommunityModel coverImageKey(String? coverImageKey);

  CommunityModel welcomeScreen(String? welcomeScreen);

  CommunityModel enableWelcomeScreen(bool? enableWelcomeScreen);

  CommunityModel lastActivity(dynamic lastActivity);

  CommunityModel totalMembers(int? totalMembers);

  CommunityModel createdAt(DateTime? createdAt);

  CommunityModel tags(List<CommunityTagModel>? tags);

  CommunityModel settings(CommunitySettingsModel? settings);

  CommunityModel category(CommunityCategoryModel? category);

  CommunityModel isFeatured(bool? isFeatured);

  CommunityModel communityRole(CommunityRoleModel? communityRole);

  CommunityModel isMember(bool? isMember);

  CommunityModel isPinned(bool? isPinned);

  CommunityModel hasNewContent(bool? hasNewContent);

  CommunityModel isStale(bool? isStale);

  CommunityModel communityPermissions(List<String>? communityPermissions);

  CommunityModel pictureUrl(String? pictureUrl);

  CommunityModel coverImageUrl(String? coverImageUrl);

  CommunityModel socials(List<CommunityLinkModel>? socials);

  CommunityModel interests(List<String>? interests);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CommunityModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CommunityModel(...).copyWith(id: 12, name: "My name")
  /// ````
  CommunityModel call({
    int? id,
    int? userId,
    int? categoryId,
    String? name,
    String? slug,
    String? description,
    String? about,
    bool? isApproved,
    String? pictureKey,
    String? coverImageKey,
    String? welcomeScreen,
    bool? enableWelcomeScreen,
    dynamic lastActivity,
    int? totalMembers,
    DateTime? createdAt,
    List<CommunityTagModel>? tags,
    CommunitySettingsModel? settings,
    CommunityCategoryModel? category,
    bool? isFeatured,
    CommunityRoleModel? communityRole,
    bool? isMember,
    bool? isPinned,
    bool? hasNewContent,
    bool? isStale,
    List<String>? communityPermissions,
    String? pictureUrl,
    String? coverImageUrl,
    List<CommunityLinkModel>? socials,
    List<String>? interests,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCommunityModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCommunityModel.copyWith.fieldName(...)`
class _$CommunityModelCWProxyImpl implements _$CommunityModelCWProxy {
  const _$CommunityModelCWProxyImpl(this._value);

  final CommunityModel _value;

  @override
  CommunityModel id(int? id) => this(id: id);

  @override
  CommunityModel userId(int? userId) => this(userId: userId);

  @override
  CommunityModel categoryId(int? categoryId) => this(categoryId: categoryId);

  @override
  CommunityModel name(String? name) => this(name: name);

  @override
  CommunityModel slug(String? slug) => this(slug: slug);

  @override
  CommunityModel description(String? description) =>
      this(description: description);

  @override
  CommunityModel about(String? about) => this(about: about);

  @override
  CommunityModel isApproved(bool? isApproved) => this(isApproved: isApproved);

  @override
  CommunityModel pictureKey(String? pictureKey) => this(pictureKey: pictureKey);

  @override
  CommunityModel coverImageKey(String? coverImageKey) =>
      this(coverImageKey: coverImageKey);

  @override
  CommunityModel welcomeScreen(String? welcomeScreen) =>
      this(welcomeScreen: welcomeScreen);

  @override
  CommunityModel enableWelcomeScreen(bool? enableWelcomeScreen) =>
      this(enableWelcomeScreen: enableWelcomeScreen);

  @override
  CommunityModel lastActivity(dynamic lastActivity) =>
      this(lastActivity: lastActivity);

  @override
  CommunityModel totalMembers(int? totalMembers) =>
      this(totalMembers: totalMembers);

  @override
  CommunityModel createdAt(DateTime? createdAt) => this(createdAt: createdAt);

  @override
  CommunityModel tags(List<CommunityTagModel>? tags) => this(tags: tags);

  @override
  CommunityModel settings(CommunitySettingsModel? settings) =>
      this(settings: settings);

  @override
  CommunityModel category(CommunityCategoryModel? category) =>
      this(category: category);

  @override
  CommunityModel isFeatured(bool? isFeatured) => this(isFeatured: isFeatured);

  @override
  CommunityModel communityRole(CommunityRoleModel? communityRole) =>
      this(communityRole: communityRole);

  @override
  CommunityModel isMember(bool? isMember) => this(isMember: isMember);

  @override
  CommunityModel isPinned(bool? isPinned) => this(isPinned: isPinned);

  @override
  CommunityModel hasNewContent(bool? hasNewContent) =>
      this(hasNewContent: hasNewContent);

  @override
  CommunityModel isStale(bool? isStale) => this(isStale: isStale);

  @override
  CommunityModel communityPermissions(List<String>? communityPermissions) =>
      this(communityPermissions: communityPermissions);

  @override
  CommunityModel pictureUrl(String? pictureUrl) => this(pictureUrl: pictureUrl);

  @override
  CommunityModel coverImageUrl(String? coverImageUrl) =>
      this(coverImageUrl: coverImageUrl);

  @override
  CommunityModel socials(List<CommunityLinkModel>? socials) =>
      this(socials: socials);

  @override
  CommunityModel interests(List<String>? interests) =>
      this(interests: interests);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CommunityModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CommunityModel(...).copyWith(id: 12, name: "My name")
  /// ````
  CommunityModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? userId = const $CopyWithPlaceholder(),
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? slug = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? about = const $CopyWithPlaceholder(),
    Object? isApproved = const $CopyWithPlaceholder(),
    Object? pictureKey = const $CopyWithPlaceholder(),
    Object? coverImageKey = const $CopyWithPlaceholder(),
    Object? welcomeScreen = const $CopyWithPlaceholder(),
    Object? enableWelcomeScreen = const $CopyWithPlaceholder(),
    Object? lastActivity = const $CopyWithPlaceholder(),
    Object? totalMembers = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? tags = const $CopyWithPlaceholder(),
    Object? settings = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
    Object? isFeatured = const $CopyWithPlaceholder(),
    Object? communityRole = const $CopyWithPlaceholder(),
    Object? isMember = const $CopyWithPlaceholder(),
    Object? isPinned = const $CopyWithPlaceholder(),
    Object? hasNewContent = const $CopyWithPlaceholder(),
    Object? isStale = const $CopyWithPlaceholder(),
    Object? communityPermissions = const $CopyWithPlaceholder(),
    Object? pictureUrl = const $CopyWithPlaceholder(),
    Object? coverImageUrl = const $CopyWithPlaceholder(),
    Object? socials = const $CopyWithPlaceholder(),
    Object? interests = const $CopyWithPlaceholder(),
  }) {
    return CommunityModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      userId: userId == const $CopyWithPlaceholder()
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as int?,
      categoryId: categoryId == const $CopyWithPlaceholder()
          ? _value.categoryId
          // ignore: cast_nullable_to_non_nullable
          : categoryId as int?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      slug: slug == const $CopyWithPlaceholder()
          ? _value.slug
          // ignore: cast_nullable_to_non_nullable
          : slug as String?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      about: about == const $CopyWithPlaceholder()
          ? _value.about
          // ignore: cast_nullable_to_non_nullable
          : about as String?,
      isApproved: isApproved == const $CopyWithPlaceholder()
          ? _value.isApproved
          // ignore: cast_nullable_to_non_nullable
          : isApproved as bool?,
      pictureKey: pictureKey == const $CopyWithPlaceholder()
          ? _value.pictureKey
          // ignore: cast_nullable_to_non_nullable
          : pictureKey as String?,
      coverImageKey: coverImageKey == const $CopyWithPlaceholder()
          ? _value.coverImageKey
          // ignore: cast_nullable_to_non_nullable
          : coverImageKey as String?,
      welcomeScreen: welcomeScreen == const $CopyWithPlaceholder()
          ? _value.welcomeScreen
          // ignore: cast_nullable_to_non_nullable
          : welcomeScreen as String?,
      enableWelcomeScreen: enableWelcomeScreen == const $CopyWithPlaceholder()
          ? _value.enableWelcomeScreen
          // ignore: cast_nullable_to_non_nullable
          : enableWelcomeScreen as bool?,
      lastActivity:
          lastActivity == const $CopyWithPlaceholder() || lastActivity == null
              ? _value.lastActivity
              // ignore: cast_nullable_to_non_nullable
              : lastActivity as dynamic,
      totalMembers: totalMembers == const $CopyWithPlaceholder()
          ? _value.totalMembers
          // ignore: cast_nullable_to_non_nullable
          : totalMembers as int?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      tags: tags == const $CopyWithPlaceholder()
          ? _value.tags
          // ignore: cast_nullable_to_non_nullable
          : tags as List<CommunityTagModel>?,
      settings: settings == const $CopyWithPlaceholder()
          ? _value.settings
          // ignore: cast_nullable_to_non_nullable
          : settings as CommunitySettingsModel?,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as CommunityCategoryModel?,
      isFeatured: isFeatured == const $CopyWithPlaceholder()
          ? _value.isFeatured
          // ignore: cast_nullable_to_non_nullable
          : isFeatured as bool?,
      communityRole: communityRole == const $CopyWithPlaceholder()
          ? _value.communityRole
          // ignore: cast_nullable_to_non_nullable
          : communityRole as CommunityRoleModel?,
      isMember: isMember == const $CopyWithPlaceholder()
          ? _value.isMember
          // ignore: cast_nullable_to_non_nullable
          : isMember as bool?,
      isPinned: isPinned == const $CopyWithPlaceholder()
          ? _value.isPinned
          // ignore: cast_nullable_to_non_nullable
          : isPinned as bool?,
      hasNewContent: hasNewContent == const $CopyWithPlaceholder()
          ? _value.hasNewContent
          // ignore: cast_nullable_to_non_nullable
          : hasNewContent as bool?,
      isStale: isStale == const $CopyWithPlaceholder()
          ? _value.isStale
          // ignore: cast_nullable_to_non_nullable
          : isStale as bool?,
      communityPermissions: communityPermissions == const $CopyWithPlaceholder()
          ? _value.communityPermissions
          // ignore: cast_nullable_to_non_nullable
          : communityPermissions as List<String>?,
      pictureUrl: pictureUrl == const $CopyWithPlaceholder()
          ? _value.pictureUrl
          // ignore: cast_nullable_to_non_nullable
          : pictureUrl as String?,
      coverImageUrl: coverImageUrl == const $CopyWithPlaceholder()
          ? _value.coverImageUrl
          // ignore: cast_nullable_to_non_nullable
          : coverImageUrl as String?,
      socials: socials == const $CopyWithPlaceholder()
          ? _value.socials
          // ignore: cast_nullable_to_non_nullable
          : socials as List<CommunityLinkModel>?,
      interests: interests == const $CopyWithPlaceholder()
          ? _value.interests
          // ignore: cast_nullable_to_non_nullable
          : interests as List<String>?,
    );
  }
}

extension $CommunityModelCopyWith on CommunityModel {
  /// Returns a callable class that can be used as follows: `instanceOfCommunityModel.copyWith(...)` or like so:`instanceOfCommunityModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CommunityModelCWProxy get copyWith => _$CommunityModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityModel _$CommunityModelFromJson(Map<String, dynamic> json) =>
    CommunityModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      categoryId: json['categoryId'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      about: json['about'] as String?,
      isApproved: json['isApproved'] as bool?,
      pictureKey: json['pictureKey'] as String?,
      coverImageKey: json['coverImageKey'] as String?,
      welcomeScreen: json['welcomeScreen'] as String?,
      enableWelcomeScreen: json['enableWelcomeScreen'] as bool?,
      lastActivity: json['lastActivity'],
      totalMembers: json['totalMembers'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => CommunityTagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      settings: json['settings'] == null
          ? null
          : CommunitySettingsModel.fromJson(
              json['settings'] as Map<String, dynamic>),
      category: json['category'] == null
          ? null
          : CommunityCategoryModel.fromJson(
              json['category'] as Map<String, dynamic>),
      isFeatured: json['isFeatured'] as bool?,
      communityRole: json['communityRole'] == null
          ? null
          : CommunityRoleModel.fromJson(
              json['communityRole'] as Map<String, dynamic>),
      isMember: json['isMember'] as bool?,
      isPinned: json['isPinned'] as bool?,
      hasNewContent: json['hasNewContent'] as bool?,
      isStale: json['isStale'] as bool?,
      communityPermissions: (json['communityPermissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      pictureUrl: json['pictureUrl'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      socials: (json['socials'] as List<dynamic>?)
          ?.map((e) => CommunityLinkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CommunityModelToJson(CommunityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'categoryId': instance.categoryId,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'about': instance.about,
      'isApproved': instance.isApproved,
      'pictureKey': instance.pictureKey,
      'pictureUrl': instance.pictureUrl,
      'coverImageUrl': instance.coverImageUrl,
      'coverImageKey': instance.coverImageKey,
      'welcomeScreen': instance.welcomeScreen,
      'enableWelcomeScreen': instance.enableWelcomeScreen,
      'lastActivity': instance.lastActivity,
      'totalMembers': instance.totalMembers,
      'createdAt': instance.createdAt?.toIso8601String(),
      'tags': instance.tags,
      'settings': instance.settings,
      'category': instance.category,
      'isFeatured': instance.isFeatured,
      'isStale': instance.isStale,
      'isPinned': instance.isPinned,
      'communityRole': instance.communityRole,
      'isMember': instance.isMember,
      'communityPermissions': instance.communityPermissions,
      'hasNewContent': instance.hasNewContent,
      'socials': instance.socials,
      'interests': instance.interests,
    };

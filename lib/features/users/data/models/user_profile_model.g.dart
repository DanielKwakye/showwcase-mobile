// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserProfileModelCWProxy {
  UserProfileModel username(String? username);

  UserProfileModel userInfo(UserModel? userInfo);

  UserProfileModel tabs(List<UserTabModel> tabs);

  UserProfileModel userRepositories(List<UserRepositoryModel> userRepositories);

  UserProfileModel workedWiths(List<UserModel> workedWiths);

  UserProfileModel techStacks(List<UserTechStackModel> techStacks);

  UserProfileModel experiences(List<UserExperienceModel> experiences);

  UserProfileModel certifications(List<UserCertificationModel> certifications);

  UserProfileModel featuredCommunities(
      List<CommunityModel> featuredCommunities);

  UserProfileModel featuredRepositories(
      List<UserRepositoryModel> featuredRepositories);

  UserProfileModel featuredProjects(List<ShowModel> featuredProjects);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserProfileModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserProfileModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserProfileModel call({
    String? username,
    UserModel? userInfo,
    List<UserTabModel>? tabs,
    List<UserRepositoryModel>? userRepositories,
    List<UserModel>? workedWiths,
    List<UserTechStackModel>? techStacks,
    List<UserExperienceModel>? experiences,
    List<UserCertificationModel>? certifications,
    List<CommunityModel>? featuredCommunities,
    List<UserRepositoryModel>? featuredRepositories,
    List<ShowModel>? featuredProjects,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserProfileModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserProfileModel.copyWith.fieldName(...)`
class _$UserProfileModelCWProxyImpl implements _$UserProfileModelCWProxy {
  const _$UserProfileModelCWProxyImpl(this._value);

  final UserProfileModel _value;

  @override
  UserProfileModel username(String? username) => this(username: username);

  @override
  UserProfileModel userInfo(UserModel? userInfo) => this(userInfo: userInfo);

  @override
  UserProfileModel tabs(List<UserTabModel> tabs) => this(tabs: tabs);

  @override
  UserProfileModel userRepositories(
          List<UserRepositoryModel> userRepositories) =>
      this(userRepositories: userRepositories);

  @override
  UserProfileModel workedWiths(List<UserModel> workedWiths) =>
      this(workedWiths: workedWiths);

  @override
  UserProfileModel techStacks(List<UserTechStackModel> techStacks) =>
      this(techStacks: techStacks);

  @override
  UserProfileModel experiences(List<UserExperienceModel> experiences) =>
      this(experiences: experiences);

  @override
  UserProfileModel certifications(
          List<UserCertificationModel> certifications) =>
      this(certifications: certifications);

  @override
  UserProfileModel featuredCommunities(
          List<CommunityModel> featuredCommunities) =>
      this(featuredCommunities: featuredCommunities);

  @override
  UserProfileModel featuredRepositories(
          List<UserRepositoryModel> featuredRepositories) =>
      this(featuredRepositories: featuredRepositories);

  @override
  UserProfileModel featuredProjects(List<ShowModel> featuredProjects) =>
      this(featuredProjects: featuredProjects);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserProfileModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserProfileModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserProfileModel call({
    Object? username = const $CopyWithPlaceholder(),
    Object? userInfo = const $CopyWithPlaceholder(),
    Object? tabs = const $CopyWithPlaceholder(),
    Object? userRepositories = const $CopyWithPlaceholder(),
    Object? workedWiths = const $CopyWithPlaceholder(),
    Object? techStacks = const $CopyWithPlaceholder(),
    Object? experiences = const $CopyWithPlaceholder(),
    Object? certifications = const $CopyWithPlaceholder(),
    Object? featuredCommunities = const $CopyWithPlaceholder(),
    Object? featuredRepositories = const $CopyWithPlaceholder(),
    Object? featuredProjects = const $CopyWithPlaceholder(),
  }) {
    return UserProfileModel(
      username: username == const $CopyWithPlaceholder()
          ? _value.username
          // ignore: cast_nullable_to_non_nullable
          : username as String?,
      userInfo: userInfo == const $CopyWithPlaceholder()
          ? _value.userInfo
          // ignore: cast_nullable_to_non_nullable
          : userInfo as UserModel?,
      tabs: tabs == const $CopyWithPlaceholder() || tabs == null
          ? _value.tabs
          // ignore: cast_nullable_to_non_nullable
          : tabs as List<UserTabModel>,
      userRepositories: userRepositories == const $CopyWithPlaceholder() ||
              userRepositories == null
          ? _value.userRepositories
          // ignore: cast_nullable_to_non_nullable
          : userRepositories as List<UserRepositoryModel>,
      workedWiths:
          workedWiths == const $CopyWithPlaceholder() || workedWiths == null
              ? _value.workedWiths
              // ignore: cast_nullable_to_non_nullable
              : workedWiths as List<UserModel>,
      techStacks:
          techStacks == const $CopyWithPlaceholder() || techStacks == null
              ? _value.techStacks
              // ignore: cast_nullable_to_non_nullable
              : techStacks as List<UserTechStackModel>,
      experiences:
          experiences == const $CopyWithPlaceholder() || experiences == null
              ? _value.experiences
              // ignore: cast_nullable_to_non_nullable
              : experiences as List<UserExperienceModel>,
      certifications: certifications == const $CopyWithPlaceholder() ||
              certifications == null
          ? _value.certifications
          // ignore: cast_nullable_to_non_nullable
          : certifications as List<UserCertificationModel>,
      featuredCommunities:
          featuredCommunities == const $CopyWithPlaceholder() ||
                  featuredCommunities == null
              ? _value.featuredCommunities
              // ignore: cast_nullable_to_non_nullable
              : featuredCommunities as List<CommunityModel>,
      featuredRepositories:
          featuredRepositories == const $CopyWithPlaceholder() ||
                  featuredRepositories == null
              ? _value.featuredRepositories
              // ignore: cast_nullable_to_non_nullable
              : featuredRepositories as List<UserRepositoryModel>,
      featuredProjects: featuredProjects == const $CopyWithPlaceholder() ||
              featuredProjects == null
          ? _value.featuredProjects
          // ignore: cast_nullable_to_non_nullable
          : featuredProjects as List<ShowModel>,
    );
  }
}

extension $UserProfileModelCopyWith on UserProfileModel {
  /// Returns a callable class that can be used as follows: `instanceOfUserProfileModel.copyWith(...)` or like so:`instanceOfUserProfileModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserProfileModelCWProxy get copyWith => _$UserProfileModelCWProxyImpl(this);
}

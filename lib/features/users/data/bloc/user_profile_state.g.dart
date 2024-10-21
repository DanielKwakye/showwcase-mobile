// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserProfileStateCWProxy {
  UserProfileState status(UserStatus status);

  UserProfileState message(String message);

  UserProfileState userProfiles(List<UserProfileModel> userProfiles);

  UserProfileState social(Map<String, UserSocialModel> social);

  UserProfileState collaborators(Map<String, List<UserModel>> collaborators);

  UserProfileState followers(Map<String, List<UserModel>> followers);

  UserProfileState following(Map<String, List<UserModel>> following);

  UserProfileState customFeaturedShows(
      Map<String, List<ShowModel>> customFeaturedShows);

  UserProfileState customFeaturedSeries(
      Map<String, List<SeriesModel>> customFeaturedSeries);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserProfileState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserProfileState(...).copyWith(id: 12, name: "My name")
  /// ````
  UserProfileState call({
    UserStatus? status,
    String? message,
    List<UserProfileModel>? userProfiles,
    Map<String, UserSocialModel>? social,
    Map<String, List<UserModel>>? collaborators,
    Map<String, List<UserModel>>? followers,
    Map<String, List<UserModel>>? following,
    Map<String, List<ShowModel>>? customFeaturedShows,
    Map<String, List<SeriesModel>>? customFeaturedSeries,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserProfileState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserProfileState.copyWith.fieldName(...)`
class _$UserProfileStateCWProxyImpl implements _$UserProfileStateCWProxy {
  const _$UserProfileStateCWProxyImpl(this._value);

  final UserProfileState _value;

  @override
  UserProfileState status(UserStatus status) => this(status: status);

  @override
  UserProfileState message(String message) => this(message: message);

  @override
  UserProfileState userProfiles(List<UserProfileModel> userProfiles) =>
      this(userProfiles: userProfiles);

  @override
  UserProfileState social(Map<String, UserSocialModel> social) =>
      this(social: social);

  @override
  UserProfileState collaborators(Map<String, List<UserModel>> collaborators) =>
      this(collaborators: collaborators);

  @override
  UserProfileState followers(Map<String, List<UserModel>> followers) =>
      this(followers: followers);

  @override
  UserProfileState following(Map<String, List<UserModel>> following) =>
      this(following: following);

  @override
  UserProfileState customFeaturedShows(
          Map<String, List<ShowModel>> customFeaturedShows) =>
      this(customFeaturedShows: customFeaturedShows);

  @override
  UserProfileState customFeaturedSeries(
          Map<String, List<SeriesModel>> customFeaturedSeries) =>
      this(customFeaturedSeries: customFeaturedSeries);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserProfileState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserProfileState(...).copyWith(id: 12, name: "My name")
  /// ````
  UserProfileState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? userProfiles = const $CopyWithPlaceholder(),
    Object? social = const $CopyWithPlaceholder(),
    Object? collaborators = const $CopyWithPlaceholder(),
    Object? followers = const $CopyWithPlaceholder(),
    Object? following = const $CopyWithPlaceholder(),
    Object? customFeaturedShows = const $CopyWithPlaceholder(),
    Object? customFeaturedSeries = const $CopyWithPlaceholder(),
  }) {
    return UserProfileState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as UserStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      userProfiles:
          userProfiles == const $CopyWithPlaceholder() || userProfiles == null
              ? _value.userProfiles
              // ignore: cast_nullable_to_non_nullable
              : userProfiles as List<UserProfileModel>,
      social: social == const $CopyWithPlaceholder() || social == null
          ? _value.social
          // ignore: cast_nullable_to_non_nullable
          : social as Map<String, UserSocialModel>,
      collaborators:
          collaborators == const $CopyWithPlaceholder() || collaborators == null
              ? _value.collaborators
              // ignore: cast_nullable_to_non_nullable
              : collaborators as Map<String, List<UserModel>>,
      followers: followers == const $CopyWithPlaceholder() || followers == null
          ? _value.followers
          // ignore: cast_nullable_to_non_nullable
          : followers as Map<String, List<UserModel>>,
      following: following == const $CopyWithPlaceholder() || following == null
          ? _value.following
          // ignore: cast_nullable_to_non_nullable
          : following as Map<String, List<UserModel>>,
      customFeaturedShows:
          customFeaturedShows == const $CopyWithPlaceholder() ||
                  customFeaturedShows == null
              ? _value.customFeaturedShows
              // ignore: cast_nullable_to_non_nullable
              : customFeaturedShows as Map<String, List<ShowModel>>,
      customFeaturedSeries:
          customFeaturedSeries == const $CopyWithPlaceholder() ||
                  customFeaturedSeries == null
              ? _value.customFeaturedSeries
              // ignore: cast_nullable_to_non_nullable
              : customFeaturedSeries as Map<String, List<SeriesModel>>,
    );
  }
}

extension $UserProfileStateCopyWith on UserProfileState {
  /// Returns a callable class that can be used as follows: `instanceOfUserProfileState.copyWith(...)` or like so:`instanceOfUserProfileState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserProfileStateCWProxy get copyWith => _$UserProfileStateCWProxyImpl(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_social_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserSocialModelCWProxy {
  UserSocialModel links(List<UserLinkModel>? links);

  UserSocialModel userId(int? userId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserSocialModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserSocialModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserSocialModel call({
    List<UserLinkModel>? links,
    int? userId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserSocialModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserSocialModel.copyWith.fieldName(...)`
class _$UserSocialModelCWProxyImpl implements _$UserSocialModelCWProxy {
  const _$UserSocialModelCWProxyImpl(this._value);

  final UserSocialModel _value;

  @override
  UserSocialModel links(List<UserLinkModel>? links) => this(links: links);

  @override
  UserSocialModel userId(int? userId) => this(userId: userId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserSocialModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserSocialModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserSocialModel call({
    Object? links = const $CopyWithPlaceholder(),
    Object? userId = const $CopyWithPlaceholder(),
  }) {
    return UserSocialModel(
      links: links == const $CopyWithPlaceholder()
          ? _value.links
          // ignore: cast_nullable_to_non_nullable
          : links as List<UserLinkModel>?,
      userId: userId == const $CopyWithPlaceholder()
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as int?,
    );
  }
}

extension $UserSocialModelCopyWith on UserSocialModel {
  /// Returns a callable class that can be used as follows: `instanceOfUserSocialModel.copyWith(...)` or like so:`instanceOfUserSocialModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserSocialModelCWProxy get copyWith => _$UserSocialModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSocialModel _$UserSocialModelFromJson(Map<String, dynamic> json) =>
    UserSocialModel(
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => UserLinkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      userId: json['userId'] as int?,
    );

Map<String, dynamic> _$UserSocialModelToJson(UserSocialModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('links', instance.links?.map((e) => e.toJson()).toList());
  writeNotNull('userId', instance.userId);
  return val;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_tech_stack_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserTechStackModelCWProxy {
  UserTechStackModel id(int? id);

  UserTechStackModel userId(int? userId);

  UserTechStackModel stackId(int? stackId);

  UserTechStackModel experience(int? experience);

  UserTechStackModel experienceId(int? experienceId);

  UserTechStackModel isFeatured(bool? isFeatured);

  UserTechStackModel createdAt(DateTime? createdAt);

  UserTechStackModel updatedAt(DateTime? updatedAt);

  UserTechStackModel stack(UserStackModel? stack);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserTechStackModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserTechStackModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserTechStackModel call({
    int? id,
    int? userId,
    int? stackId,
    int? experience,
    int? experienceId,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserStackModel? stack,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserTechStackModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserTechStackModel.copyWith.fieldName(...)`
class _$UserTechStackModelCWProxyImpl implements _$UserTechStackModelCWProxy {
  const _$UserTechStackModelCWProxyImpl(this._value);

  final UserTechStackModel _value;

  @override
  UserTechStackModel id(int? id) => this(id: id);

  @override
  UserTechStackModel userId(int? userId) => this(userId: userId);

  @override
  UserTechStackModel stackId(int? stackId) => this(stackId: stackId);

  @override
  UserTechStackModel experience(int? experience) =>
      this(experience: experience);

  @override
  UserTechStackModel experienceId(int? experienceId) =>
      this(experienceId: experienceId);

  @override
  UserTechStackModel isFeatured(bool? isFeatured) =>
      this(isFeatured: isFeatured);

  @override
  UserTechStackModel createdAt(DateTime? createdAt) =>
      this(createdAt: createdAt);

  @override
  UserTechStackModel updatedAt(DateTime? updatedAt) =>
      this(updatedAt: updatedAt);

  @override
  UserTechStackModel stack(UserStackModel? stack) => this(stack: stack);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserTechStackModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserTechStackModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserTechStackModel call({
    Object? id = const $CopyWithPlaceholder(),
    Object? userId = const $CopyWithPlaceholder(),
    Object? stackId = const $CopyWithPlaceholder(),
    Object? experience = const $CopyWithPlaceholder(),
    Object? experienceId = const $CopyWithPlaceholder(),
    Object? isFeatured = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? stack = const $CopyWithPlaceholder(),
  }) {
    return UserTechStackModel(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      userId: userId == const $CopyWithPlaceholder()
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as int?,
      stackId: stackId == const $CopyWithPlaceholder()
          ? _value.stackId
          // ignore: cast_nullable_to_non_nullable
          : stackId as int?,
      experience: experience == const $CopyWithPlaceholder()
          ? _value.experience
          // ignore: cast_nullable_to_non_nullable
          : experience as int?,
      experienceId: experienceId == const $CopyWithPlaceholder()
          ? _value.experienceId
          // ignore: cast_nullable_to_non_nullable
          : experienceId as int?,
      isFeatured: isFeatured == const $CopyWithPlaceholder()
          ? _value.isFeatured
          // ignore: cast_nullable_to_non_nullable
          : isFeatured as bool?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
      stack: stack == const $CopyWithPlaceholder()
          ? _value.stack
          // ignore: cast_nullable_to_non_nullable
          : stack as UserStackModel?,
    );
  }
}

extension $UserTechStackModelCopyWith on UserTechStackModel {
  /// Returns a callable class that can be used as follows: `instanceOfUserTechStackModel.copyWith(...)` or like so:`instanceOfUserTechStackModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserTechStackModelCWProxy get copyWith =>
      _$UserTechStackModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTechStackModel _$UserTechStackModelFromJson(Map<String, dynamic> json) =>
    UserTechStackModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      stackId: json['stackId'] as int?,
      experience: json['experience'] as int?,
      experienceId: json['experienceId'] as int?,
      isFeatured: json['isFeatured'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      stack: json['stack'] == null
          ? null
          : UserStackModel.fromJson(json['stack'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserTechStackModelToJson(UserTechStackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'stackId': instance.stackId,
      'experience': instance.experience,
      'experienceId': instance.experienceId,
      'isFeatured': instance.isFeatured,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'stack': instance.stack?.toJson(),
    };

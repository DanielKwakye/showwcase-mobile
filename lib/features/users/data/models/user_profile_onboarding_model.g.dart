// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_onboarding_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserProfileOnboardingModelCWProxy {
  UserProfileOnboardingModel workedwith(bool? workedwith);

  UserProfileOnboardingModel repos(bool? repos);

  UserProfileOnboardingModel positions(bool? positions);

  UserProfileOnboardingModel completed(bool? completed);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserProfileOnboardingModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserProfileOnboardingModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserProfileOnboardingModel call({
    bool? workedwith,
    bool? repos,
    bool? positions,
    bool? completed,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserProfileOnboardingModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserProfileOnboardingModel.copyWith.fieldName(...)`
class _$UserProfileOnboardingModelCWProxyImpl
    implements _$UserProfileOnboardingModelCWProxy {
  const _$UserProfileOnboardingModelCWProxyImpl(this._value);

  final UserProfileOnboardingModel _value;

  @override
  UserProfileOnboardingModel workedwith(bool? workedwith) =>
      this(workedwith: workedwith);

  @override
  UserProfileOnboardingModel repos(bool? repos) => this(repos: repos);

  @override
  UserProfileOnboardingModel positions(bool? positions) =>
      this(positions: positions);

  @override
  UserProfileOnboardingModel completed(bool? completed) =>
      this(completed: completed);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserProfileOnboardingModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserProfileOnboardingModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserProfileOnboardingModel call({
    Object? workedwith = const $CopyWithPlaceholder(),
    Object? repos = const $CopyWithPlaceholder(),
    Object? positions = const $CopyWithPlaceholder(),
    Object? completed = const $CopyWithPlaceholder(),
  }) {
    return UserProfileOnboardingModel(
      workedwith: workedwith == const $CopyWithPlaceholder()
          ? _value.workedwith
          // ignore: cast_nullable_to_non_nullable
          : workedwith as bool?,
      repos: repos == const $CopyWithPlaceholder()
          ? _value.repos
          // ignore: cast_nullable_to_non_nullable
          : repos as bool?,
      positions: positions == const $CopyWithPlaceholder()
          ? _value.positions
          // ignore: cast_nullable_to_non_nullable
          : positions as bool?,
      completed: completed == const $CopyWithPlaceholder()
          ? _value.completed
          // ignore: cast_nullable_to_non_nullable
          : completed as bool?,
    );
  }
}

extension $UserProfileOnboardingModelCopyWith on UserProfileOnboardingModel {
  /// Returns a callable class that can be used as follows: `instanceOfUserProfileOnboardingModel.copyWith(...)` or like so:`instanceOfUserProfileOnboardingModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserProfileOnboardingModelCWProxy get copyWith =>
      _$UserProfileOnboardingModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileOnboardingModel _$UserProfileOnboardingModelFromJson(
        Map<String, dynamic> json) =>
    UserProfileOnboardingModel(
      workedwith: json['workedwith'] as bool?,
      repos: json['repos'] as bool?,
      positions: json['positions'] as bool?,
      completed: json['completed'] as bool?,
    );

Map<String, dynamic> _$UserProfileOnboardingModelToJson(
    UserProfileOnboardingModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('workedwith', instance.workedwith);
  writeNotNull('repos', instance.repos);
  writeNotNull('positions', instance.positions);
  writeNotNull('completed', instance.completed);
  return val;
}

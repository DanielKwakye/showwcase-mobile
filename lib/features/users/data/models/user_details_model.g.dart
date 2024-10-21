// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserDetailsModelCWProxy {
  UserDetailsModel languages(List<String> languages);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserDetailsModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserDetailsModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserDetailsModel call({
    List<String>? languages,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserDetailsModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserDetailsModel.copyWith.fieldName(...)`
class _$UserDetailsModelCWProxyImpl implements _$UserDetailsModelCWProxy {
  const _$UserDetailsModelCWProxyImpl(this._value);

  final UserDetailsModel _value;

  @override
  UserDetailsModel languages(List<String> languages) =>
      this(languages: languages);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserDetailsModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserDetailsModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserDetailsModel call({
    Object? languages = const $CopyWithPlaceholder(),
  }) {
    return UserDetailsModel(
      languages: languages == const $CopyWithPlaceholder() || languages == null
          ? _value.languages
          // ignore: cast_nullable_to_non_nullable
          : languages as List<String>,
    );
  }
}

extension $UserDetailsModelCopyWith on UserDetailsModel {
  /// Returns a callable class that can be used as follows: `instanceOfUserDetailsModel.copyWith(...)` or like so:`instanceOfUserDetailsModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserDetailsModelCWProxy get copyWith => _$UserDetailsModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetailsModel _$UserDetailsModelFromJson(Map<String, dynamic> json) =>
    UserDetailsModel(
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserDetailsModelToJson(UserDetailsModel instance) =>
    <String, dynamic>{
      'languages': instance.languages,
    };

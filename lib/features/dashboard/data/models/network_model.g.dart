// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NetworkModelCWProxy {
  NetworkModel profileViews(int? profileViews);

  NetworkModel inviteCodeUsed(int? inviteCodeUsed);

  NetworkModel newWorkedwiths(int? newWorkedwiths);

  NetworkModel newFollowers(int? newFollowers);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NetworkModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NetworkModel(...).copyWith(id: 12, name: "My name")
  /// ````
  NetworkModel call({
    int? profileViews,
    int? inviteCodeUsed,
    int? newWorkedwiths,
    int? newFollowers,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNetworkModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNetworkModel.copyWith.fieldName(...)`
class _$NetworkModelCWProxyImpl implements _$NetworkModelCWProxy {
  const _$NetworkModelCWProxyImpl(this._value);

  final NetworkModel _value;

  @override
  NetworkModel profileViews(int? profileViews) =>
      this(profileViews: profileViews);

  @override
  NetworkModel inviteCodeUsed(int? inviteCodeUsed) =>
      this(inviteCodeUsed: inviteCodeUsed);

  @override
  NetworkModel newWorkedwiths(int? newWorkedwiths) =>
      this(newWorkedwiths: newWorkedwiths);

  @override
  NetworkModel newFollowers(int? newFollowers) =>
      this(newFollowers: newFollowers);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NetworkModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NetworkModel(...).copyWith(id: 12, name: "My name")
  /// ````
  NetworkModel call({
    Object? profileViews = const $CopyWithPlaceholder(),
    Object? inviteCodeUsed = const $CopyWithPlaceholder(),
    Object? newWorkedwiths = const $CopyWithPlaceholder(),
    Object? newFollowers = const $CopyWithPlaceholder(),
  }) {
    return NetworkModel(
      profileViews: profileViews == const $CopyWithPlaceholder()
          ? _value.profileViews
          // ignore: cast_nullable_to_non_nullable
          : profileViews as int?,
      inviteCodeUsed: inviteCodeUsed == const $CopyWithPlaceholder()
          ? _value.inviteCodeUsed
          // ignore: cast_nullable_to_non_nullable
          : inviteCodeUsed as int?,
      newWorkedwiths: newWorkedwiths == const $CopyWithPlaceholder()
          ? _value.newWorkedwiths
          // ignore: cast_nullable_to_non_nullable
          : newWorkedwiths as int?,
      newFollowers: newFollowers == const $CopyWithPlaceholder()
          ? _value.newFollowers
          // ignore: cast_nullable_to_non_nullable
          : newFollowers as int?,
    );
  }
}

extension $NetworkModelCopyWith on NetworkModel {
  /// Returns a callable class that can be used as follows: `instanceOfNetworkModel.copyWith(...)` or like so:`instanceOfNetworkModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NetworkModelCWProxy get copyWith => _$NetworkModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkModel _$NetworkModelFromJson(Map<String, dynamic> json) => NetworkModel(
      profileViews: json['profileViews'] as int?,
      inviteCodeUsed: json['inviteCodeUsed'] as int?,
      newWorkedwiths: json['newWorkedwiths'] as int?,
      newFollowers: json['newFollowers'] as int?,
    );

Map<String, dynamic> _$NetworkModelToJson(NetworkModel instance) =>
    <String, dynamic>{
      'profileViews': instance.profileViews,
      'inviteCodeUsed': instance.inviteCodeUsed,
      'newWorkedwiths': instance.newWorkedwiths,
      'newFollowers': instance.newFollowers,
    };

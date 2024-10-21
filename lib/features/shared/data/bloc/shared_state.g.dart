// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SharedStateCWProxy {
  SharedState status(SharedStatus status);

  SharedState message(String message);

  SharedState twitter(SharedTwitterModel? twitter);

  SharedState socialLinkIcons(List<SharedSocialLinkIconModel> socialLinkIcons);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SharedState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SharedState(...).copyWith(id: 12, name: "My name")
  /// ````
  SharedState call({
    SharedStatus? status,
    String? message,
    SharedTwitterModel? twitter,
    List<SharedSocialLinkIconModel>? socialLinkIcons,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSharedState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSharedState.copyWith.fieldName(...)`
class _$SharedStateCWProxyImpl implements _$SharedStateCWProxy {
  const _$SharedStateCWProxyImpl(this._value);

  final SharedState _value;

  @override
  SharedState status(SharedStatus status) => this(status: status);

  @override
  SharedState message(String message) => this(message: message);

  @override
  SharedState twitter(SharedTwitterModel? twitter) => this(twitter: twitter);

  @override
  SharedState socialLinkIcons(
          List<SharedSocialLinkIconModel> socialLinkIcons) =>
      this(socialLinkIcons: socialLinkIcons);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SharedState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SharedState(...).copyWith(id: 12, name: "My name")
  /// ````
  SharedState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? twitter = const $CopyWithPlaceholder(),
    Object? socialLinkIcons = const $CopyWithPlaceholder(),
  }) {
    return SharedState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as SharedStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      twitter: twitter == const $CopyWithPlaceholder()
          ? _value.twitter
          // ignore: cast_nullable_to_non_nullable
          : twitter as SharedTwitterModel?,
      socialLinkIcons: socialLinkIcons == const $CopyWithPlaceholder() ||
              socialLinkIcons == null
          ? _value.socialLinkIcons
          // ignore: cast_nullable_to_non_nullable
          : socialLinkIcons as List<SharedSocialLinkIconModel>,
    );
  }
}

extension $SharedStateCopyWith on SharedState {
  /// Returns a callable class that can be used as follows: `instanceOfSharedState.copyWith(...)` or like so:`instanceOfSharedState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SharedStateCWProxy get copyWith => _$SharedStateCWProxyImpl(this);
}

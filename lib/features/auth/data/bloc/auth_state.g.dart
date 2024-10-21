// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthStateCWProxy {
  AuthState status(AuthStatus status);

  AuthState message(String message);

  AuthState extra(dynamic extra);

  AuthState getStartedReason(GetStartedReason? getStartedReason);

  AuthState interests(List<InterestModel> interests);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthState(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthState call({
    AuthStatus? status,
    String? message,
    dynamic extra,
    GetStartedReason? getStartedReason,
    List<InterestModel>? interests,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuthState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuthState.copyWith.fieldName(...)`
class _$AuthStateCWProxyImpl implements _$AuthStateCWProxy {
  const _$AuthStateCWProxyImpl(this._value);

  final AuthState _value;

  @override
  AuthState status(AuthStatus status) => this(status: status);

  @override
  AuthState message(String message) => this(message: message);

  @override
  AuthState extra(dynamic extra) => this(extra: extra);

  @override
  AuthState getStartedReason(GetStartedReason? getStartedReason) =>
      this(getStartedReason: getStartedReason);

  @override
  AuthState interests(List<InterestModel> interests) =>
      this(interests: interests);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuthState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuthState(...).copyWith(id: 12, name: "My name")
  /// ````
  AuthState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? extra = const $CopyWithPlaceholder(),
    Object? getStartedReason = const $CopyWithPlaceholder(),
    Object? interests = const $CopyWithPlaceholder(),
  }) {
    return AuthState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as AuthStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      extra: extra == const $CopyWithPlaceholder() || extra == null
          ? _value.extra
          // ignore: cast_nullable_to_non_nullable
          : extra as dynamic,
      getStartedReason: getStartedReason == const $CopyWithPlaceholder()
          ? _value.getStartedReason
          // ignore: cast_nullable_to_non_nullable
          : getStartedReason as GetStartedReason?,
      interests: interests == const $CopyWithPlaceholder() || interests == null
          ? _value.interests
          // ignore: cast_nullable_to_non_nullable
          : interests as List<InterestModel>,
    );
  }
}

extension $AuthStateCopyWith on AuthState {
  /// Returns a callable class that can be used as follows: `instanceOfAuthState.copyWith(...)` or like so:`instanceOfAuthState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthStateCWProxy get copyWith => _$AuthStateCWProxyImpl(this);
}

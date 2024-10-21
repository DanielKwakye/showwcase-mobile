// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UsersStateCWProxy {
  UsersState status(UserStatus status);

  UsersState message(String message);

  UsersState users(List<UserModel> users);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UsersState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UsersState(...).copyWith(id: 12, name: "My name")
  /// ````
  UsersState call({
    UserStatus? status,
    String? message,
    List<UserModel>? users,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUsersState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUsersState.copyWith.fieldName(...)`
class _$UsersStateCWProxyImpl implements _$UsersStateCWProxy {
  const _$UsersStateCWProxyImpl(this._value);

  final UsersState _value;

  @override
  UsersState status(UserStatus status) => this(status: status);

  @override
  UsersState message(String message) => this(message: message);

  @override
  UsersState users(List<UserModel> users) => this(users: users);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UsersState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UsersState(...).copyWith(id: 12, name: "My name")
  /// ````
  UsersState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? users = const $CopyWithPlaceholder(),
  }) {
    return UsersState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as UserStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      users: users == const $CopyWithPlaceholder() || users == null
          ? _value.users
          // ignore: cast_nullable_to_non_nullable
          : users as List<UserModel>,
    );
  }
}

extension $UsersStateCopyWith on UsersState {
  /// Returns a callable class that can be used as follows: `instanceOfUsersState.copyWith(...)` or like so:`instanceOfUsersState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UsersStateCWProxy get copyWith => _$UsersStateCWProxyImpl(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_upvoters_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ShowUpVotersStateCWProxy {
  ShowUpVotersState status(ShowsStatus status);

  ShowUpVotersState message(String message);

  ShowUpVotersState voters(List<UserModel> voters);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShowUpVotersState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShowUpVotersState(...).copyWith(id: 12, name: "My name")
  /// ````
  ShowUpVotersState call({
    ShowsStatus? status,
    String? message,
    List<UserModel>? voters,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfShowUpVotersState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfShowUpVotersState.copyWith.fieldName(...)`
class _$ShowUpVotersStateCWProxyImpl implements _$ShowUpVotersStateCWProxy {
  const _$ShowUpVotersStateCWProxyImpl(this._value);

  final ShowUpVotersState _value;

  @override
  ShowUpVotersState status(ShowsStatus status) => this(status: status);

  @override
  ShowUpVotersState message(String message) => this(message: message);

  @override
  ShowUpVotersState voters(List<UserModel> voters) => this(voters: voters);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShowUpVotersState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShowUpVotersState(...).copyWith(id: 12, name: "My name")
  /// ````
  ShowUpVotersState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? voters = const $CopyWithPlaceholder(),
  }) {
    return ShowUpVotersState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ShowsStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      voters: voters == const $CopyWithPlaceholder() || voters == null
          ? _value.voters
          // ignore: cast_nullable_to_non_nullable
          : voters as List<UserModel>,
    );
  }
}

extension $ShowUpVotersStateCopyWith on ShowUpVotersState {
  /// Returns a callable class that can be used as follows: `instanceOfShowUpVotersState.copyWith(...)` or like so:`instanceOfShowUpVotersState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ShowUpVotersStateCWProxy get copyWith =>
      _$ShowUpVotersStateCWProxyImpl(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_up_voters_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ThreadUpVotersStateCWProxy {
  ThreadUpVotersState status(ThreadStatus status);

  ThreadUpVotersState message(String message);

  ThreadUpVotersState voters(List<UserModel> voters);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadUpVotersState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadUpVotersState(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadUpVotersState call({
    ThreadStatus? status,
    String? message,
    List<UserModel>? voters,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfThreadUpVotersState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfThreadUpVotersState.copyWith.fieldName(...)`
class _$ThreadUpVotersStateCWProxyImpl implements _$ThreadUpVotersStateCWProxy {
  const _$ThreadUpVotersStateCWProxyImpl(this._value);

  final ThreadUpVotersState _value;

  @override
  ThreadUpVotersState status(ThreadStatus status) => this(status: status);

  @override
  ThreadUpVotersState message(String message) => this(message: message);

  @override
  ThreadUpVotersState voters(List<UserModel> voters) => this(voters: voters);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadUpVotersState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadUpVotersState(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadUpVotersState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? voters = const $CopyWithPlaceholder(),
  }) {
    return ThreadUpVotersState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ThreadStatus,
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

extension $ThreadUpVotersStateCopyWith on ThreadUpVotersState {
  /// Returns a callable class that can be used as follows: `instanceOfThreadUpVotersState.copyWith(...)` or like so:`instanceOfThreadUpVotersState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ThreadUpVotersStateCWProxy get copyWith =>
      _$ThreadUpVotersStateCWProxyImpl(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_poll_voters_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ThreadPollVotersStateCWProxy {
  ThreadPollVotersState status(ThreadStatus status);

  ThreadPollVotersState message(String message);

  ThreadPollVotersState voters(List<ThreadVoterModel> voters);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadPollVotersState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadPollVotersState(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadPollVotersState call({
    ThreadStatus? status,
    String? message,
    List<ThreadVoterModel>? voters,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfThreadPollVotersState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfThreadPollVotersState.copyWith.fieldName(...)`
class _$ThreadPollVotersStateCWProxyImpl
    implements _$ThreadPollVotersStateCWProxy {
  const _$ThreadPollVotersStateCWProxyImpl(this._value);

  final ThreadPollVotersState _value;

  @override
  ThreadPollVotersState status(ThreadStatus status) => this(status: status);

  @override
  ThreadPollVotersState message(String message) => this(message: message);

  @override
  ThreadPollVotersState voters(List<ThreadVoterModel> voters) =>
      this(voters: voters);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadPollVotersState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadPollVotersState(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadPollVotersState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? voters = const $CopyWithPlaceholder(),
  }) {
    return ThreadPollVotersState(
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
          : voters as List<ThreadVoterModel>,
    );
  }
}

extension $ThreadPollVotersStateCopyWith on ThreadPollVotersState {
  /// Returns a callable class that can be used as follows: `instanceOfThreadPollVotersState.copyWith(...)` or like so:`instanceOfThreadPollVotersState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ThreadPollVotersStateCWProxy get copyWith =>
      _$ThreadPollVotersStateCWProxyImpl(this);
}

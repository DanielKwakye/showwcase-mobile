// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ThreadStateCWProxy {
  ThreadState status(ThreadStatus status);

  ThreadState message(String message);

  ThreadState threads(List<ThreadModel> threads);

  ThreadState data(dynamic data);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadState(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadState call({
    ThreadStatus? status,
    String? message,
    List<ThreadModel>? threads,
    dynamic data,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfThreadState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfThreadState.copyWith.fieldName(...)`
class _$ThreadStateCWProxyImpl implements _$ThreadStateCWProxy {
  const _$ThreadStateCWProxyImpl(this._value);

  final ThreadState _value;

  @override
  ThreadState status(ThreadStatus status) => this(status: status);

  @override
  ThreadState message(String message) => this(message: message);

  @override
  ThreadState threads(List<ThreadModel> threads) => this(threads: threads);

  @override
  ThreadState data(dynamic data) => this(data: data);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadState(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? threads = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
  }) {
    return ThreadState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ThreadStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      threads: threads == const $CopyWithPlaceholder() || threads == null
          ? _value.threads
          // ignore: cast_nullable_to_non_nullable
          : threads as List<ThreadModel>,
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as dynamic,
    );
  }
}

extension $ThreadStateCopyWith on ThreadState {
  /// Returns a callable class that can be used as follows: `instanceOfThreadState.copyWith(...)` or like so:`instanceOfThreadState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ThreadStateCWProxy get copyWith => _$ThreadStateCWProxyImpl(this);
}

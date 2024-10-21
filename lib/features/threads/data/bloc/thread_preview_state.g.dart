// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_preview_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ThreadPreviewStateCWProxy {
  ThreadPreviewState status(ThreadStatus status);

  ThreadPreviewState message(String message);

  ThreadPreviewState threadPreviews(List<ThreadModel> threadPreviews);

  ThreadPreviewState threadComments(Map<int, List<ThreadModel>> threadComments);

  ThreadPreviewState threadCommentReplies(
      Map<int, List<ThreadModel>> threadCommentReplies);

  ThreadPreviewState data(dynamic data);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadPreviewState call({
    ThreadStatus? status,
    String? message,
    List<ThreadModel>? threadPreviews,
    Map<int, List<ThreadModel>>? threadComments,
    Map<int, List<ThreadModel>>? threadCommentReplies,
    dynamic data,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfThreadPreviewState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfThreadPreviewState.copyWith.fieldName(...)`
class _$ThreadPreviewStateCWProxyImpl implements _$ThreadPreviewStateCWProxy {
  const _$ThreadPreviewStateCWProxyImpl(this._value);

  final ThreadPreviewState _value;

  @override
  ThreadPreviewState status(ThreadStatus status) => this(status: status);

  @override
  ThreadPreviewState message(String message) => this(message: message);

  @override
  ThreadPreviewState threadPreviews(List<ThreadModel> threadPreviews) =>
      this(threadPreviews: threadPreviews);

  @override
  ThreadPreviewState threadComments(
          Map<int, List<ThreadModel>> threadComments) =>
      this(threadComments: threadComments);

  @override
  ThreadPreviewState threadCommentReplies(
          Map<int, List<ThreadModel>> threadCommentReplies) =>
      this(threadCommentReplies: threadCommentReplies);

  @override
  ThreadPreviewState data(dynamic data) => this(data: data);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ThreadPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ThreadPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  ThreadPreviewState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? threadPreviews = const $CopyWithPlaceholder(),
    Object? threadComments = const $CopyWithPlaceholder(),
    Object? threadCommentReplies = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
  }) {
    return ThreadPreviewState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ThreadStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      threadPreviews: threadPreviews == const $CopyWithPlaceholder() ||
              threadPreviews == null
          ? _value.threadPreviews
          // ignore: cast_nullable_to_non_nullable
          : threadPreviews as List<ThreadModel>,
      threadComments: threadComments == const $CopyWithPlaceholder() ||
              threadComments == null
          ? _value.threadComments
          // ignore: cast_nullable_to_non_nullable
          : threadComments as Map<int, List<ThreadModel>>,
      threadCommentReplies:
          threadCommentReplies == const $CopyWithPlaceholder() ||
                  threadCommentReplies == null
              ? _value.threadCommentReplies
              // ignore: cast_nullable_to_non_nullable
              : threadCommentReplies as Map<int, List<ThreadModel>>,
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as dynamic,
    );
  }
}

extension $ThreadPreviewStateCopyWith on ThreadPreviewState {
  /// Returns a callable class that can be used as follows: `instanceOfThreadPreviewState.copyWith(...)` or like so:`instanceOfThreadPreviewState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ThreadPreviewStateCWProxy get copyWith =>
      _$ThreadPreviewStateCWProxyImpl(this);
}

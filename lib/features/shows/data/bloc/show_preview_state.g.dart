// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_preview_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ShowPreviewStateCWProxy {
  ShowPreviewState message(String message);

  ShowPreviewState status(ShowsStatus status);

  ShowPreviewState showPreviews(List<ShowModel> showPreviews);

  ShowPreviewState recommendedShows(Map<int, List<ShowModel>> recommendedShows);

  ShowPreviewState comments(Map<int, List<ShowCommentModel>> comments);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShowPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShowPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  ShowPreviewState call({
    String? message,
    ShowsStatus? status,
    List<ShowModel>? showPreviews,
    Map<int, List<ShowModel>>? recommendedShows,
    Map<int, List<ShowCommentModel>>? comments,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfShowPreviewState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfShowPreviewState.copyWith.fieldName(...)`
class _$ShowPreviewStateCWProxyImpl implements _$ShowPreviewStateCWProxy {
  const _$ShowPreviewStateCWProxyImpl(this._value);

  final ShowPreviewState _value;

  @override
  ShowPreviewState message(String message) => this(message: message);

  @override
  ShowPreviewState status(ShowsStatus status) => this(status: status);

  @override
  ShowPreviewState showPreviews(List<ShowModel> showPreviews) =>
      this(showPreviews: showPreviews);

  @override
  ShowPreviewState recommendedShows(
          Map<int, List<ShowModel>> recommendedShows) =>
      this(recommendedShows: recommendedShows);

  @override
  ShowPreviewState comments(Map<int, List<ShowCommentModel>> comments) =>
      this(comments: comments);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShowPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShowPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  ShowPreviewState call({
    Object? message = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? showPreviews = const $CopyWithPlaceholder(),
    Object? recommendedShows = const $CopyWithPlaceholder(),
    Object? comments = const $CopyWithPlaceholder(),
  }) {
    return ShowPreviewState(
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ShowsStatus,
      showPreviews:
          showPreviews == const $CopyWithPlaceholder() || showPreviews == null
              ? _value.showPreviews
              // ignore: cast_nullable_to_non_nullable
              : showPreviews as List<ShowModel>,
      recommendedShows: recommendedShows == const $CopyWithPlaceholder() ||
              recommendedShows == null
          ? _value.recommendedShows
          // ignore: cast_nullable_to_non_nullable
          : recommendedShows as Map<int, List<ShowModel>>,
      comments: comments == const $CopyWithPlaceholder() || comments == null
          ? _value.comments
          // ignore: cast_nullable_to_non_nullable
          : comments as Map<int, List<ShowCommentModel>>,
    );
  }
}

extension $ShowPreviewStateCopyWith on ShowPreviewState {
  /// Returns a callable class that can be used as follows: `instanceOfShowPreviewState.copyWith(...)` or like so:`instanceOfShowPreviewState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ShowPreviewStateCWProxy get copyWith => _$ShowPreviewStateCWProxyImpl(this);
}

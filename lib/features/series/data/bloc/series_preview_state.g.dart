// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_preview_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SeriesPreviewStateCWProxy {
  SeriesPreviewState message(String message);

  SeriesPreviewState status(SeriesStatus status);

  SeriesPreviewState seriesPreviews(List<SeriesModel> seriesPreviews);

  SeriesPreviewState stats(Map<int, SeriesReviewStatsModel> stats);

  SeriesPreviewState reviewers(Map<int, List<SeriesReviewerModel>> reviewers);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SeriesPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SeriesPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  SeriesPreviewState call({
    String? message,
    SeriesStatus? status,
    List<SeriesModel>? seriesPreviews,
    Map<int, SeriesReviewStatsModel>? stats,
    Map<int, List<SeriesReviewerModel>>? reviewers,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSeriesPreviewState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSeriesPreviewState.copyWith.fieldName(...)`
class _$SeriesPreviewStateCWProxyImpl implements _$SeriesPreviewStateCWProxy {
  const _$SeriesPreviewStateCWProxyImpl(this._value);

  final SeriesPreviewState _value;

  @override
  SeriesPreviewState message(String message) => this(message: message);

  @override
  SeriesPreviewState status(SeriesStatus status) => this(status: status);

  @override
  SeriesPreviewState seriesPreviews(List<SeriesModel> seriesPreviews) =>
      this(seriesPreviews: seriesPreviews);

  @override
  SeriesPreviewState stats(Map<int, SeriesReviewStatsModel> stats) =>
      this(stats: stats);

  @override
  SeriesPreviewState reviewers(Map<int, List<SeriesReviewerModel>> reviewers) =>
      this(reviewers: reviewers);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SeriesPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SeriesPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  SeriesPreviewState call({
    Object? message = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? seriesPreviews = const $CopyWithPlaceholder(),
    Object? stats = const $CopyWithPlaceholder(),
    Object? reviewers = const $CopyWithPlaceholder(),
  }) {
    return SeriesPreviewState(
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as SeriesStatus,
      seriesPreviews: seriesPreviews == const $CopyWithPlaceholder() ||
              seriesPreviews == null
          ? _value.seriesPreviews
          // ignore: cast_nullable_to_non_nullable
          : seriesPreviews as List<SeriesModel>,
      stats: stats == const $CopyWithPlaceholder() || stats == null
          ? _value.stats
          // ignore: cast_nullable_to_non_nullable
          : stats as Map<int, SeriesReviewStatsModel>,
      reviewers: reviewers == const $CopyWithPlaceholder() || reviewers == null
          ? _value.reviewers
          // ignore: cast_nullable_to_non_nullable
          : reviewers as Map<int, List<SeriesReviewerModel>>,
    );
  }
}

extension $SeriesPreviewStateCopyWith on SeriesPreviewState {
  /// Returns a callable class that can be used as follows: `instanceOfSeriesPreviewState.copyWith(...)` or like so:`instanceOfSeriesPreviewState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SeriesPreviewStateCWProxy get copyWith =>
      _$SeriesPreviewStateCWProxyImpl(this);
}

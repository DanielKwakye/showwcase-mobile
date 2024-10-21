// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_preview_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RoadmapPreviewStateCWProxy {
  RoadmapPreviewState message(String message);

  RoadmapPreviewState status(RoadmapStatus status);

  RoadmapPreviewState roadmapPreviews(List<RoadmapModel> roadmapPreviews);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RoadmapPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RoadmapPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  RoadmapPreviewState call({
    String? message,
    RoadmapStatus? status,
    List<RoadmapModel>? roadmapPreviews,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRoadmapPreviewState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRoadmapPreviewState.copyWith.fieldName(...)`
class _$RoadmapPreviewStateCWProxyImpl implements _$RoadmapPreviewStateCWProxy {
  const _$RoadmapPreviewStateCWProxyImpl(this._value);

  final RoadmapPreviewState _value;

  @override
  RoadmapPreviewState message(String message) => this(message: message);

  @override
  RoadmapPreviewState status(RoadmapStatus status) => this(status: status);

  @override
  RoadmapPreviewState roadmapPreviews(List<RoadmapModel> roadmapPreviews) =>
      this(roadmapPreviews: roadmapPreviews);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RoadmapPreviewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RoadmapPreviewState(...).copyWith(id: 12, name: "My name")
  /// ````
  RoadmapPreviewState call({
    Object? message = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? roadmapPreviews = const $CopyWithPlaceholder(),
  }) {
    return RoadmapPreviewState(
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as RoadmapStatus,
      roadmapPreviews: roadmapPreviews == const $CopyWithPlaceholder() ||
              roadmapPreviews == null
          ? _value.roadmapPreviews
          // ignore: cast_nullable_to_non_nullable
          : roadmapPreviews as List<RoadmapModel>,
    );
  }
}

extension $RoadmapPreviewStateCopyWith on RoadmapPreviewState {
  /// Returns a callable class that can be used as follows: `instanceOfRoadmapPreviewState.copyWith(...)` or like so:`instanceOfRoadmapPreviewState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RoadmapPreviewStateCWProxy get copyWith =>
      _$RoadmapPreviewStateCWProxyImpl(this);
}

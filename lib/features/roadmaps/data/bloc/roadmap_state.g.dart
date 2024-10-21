// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RoadmapStateCWProxy {
  RoadmapState status(RoadmapStatus status);

  RoadmapState message(String message);

  RoadmapState roadmaps(List<RoadmapModel> roadmaps);

  RoadmapState roadmapReaders(Map<int, RoadmapReadersModel> roadmapReaders);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RoadmapState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RoadmapState(...).copyWith(id: 12, name: "My name")
  /// ````
  RoadmapState call({
    RoadmapStatus? status,
    String? message,
    List<RoadmapModel>? roadmaps,
    Map<int, RoadmapReadersModel>? roadmapReaders,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRoadmapState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRoadmapState.copyWith.fieldName(...)`
class _$RoadmapStateCWProxyImpl implements _$RoadmapStateCWProxy {
  const _$RoadmapStateCWProxyImpl(this._value);

  final RoadmapState _value;

  @override
  RoadmapState status(RoadmapStatus status) => this(status: status);

  @override
  RoadmapState message(String message) => this(message: message);

  @override
  RoadmapState roadmaps(List<RoadmapModel> roadmaps) =>
      this(roadmaps: roadmaps);

  @override
  RoadmapState roadmapReaders(Map<int, RoadmapReadersModel> roadmapReaders) =>
      this(roadmapReaders: roadmapReaders);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RoadmapState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RoadmapState(...).copyWith(id: 12, name: "My name")
  /// ````
  RoadmapState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? roadmaps = const $CopyWithPlaceholder(),
    Object? roadmapReaders = const $CopyWithPlaceholder(),
  }) {
    return RoadmapState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as RoadmapStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      roadmaps: roadmaps == const $CopyWithPlaceholder() || roadmaps == null
          ? _value.roadmaps
          // ignore: cast_nullable_to_non_nullable
          : roadmaps as List<RoadmapModel>,
      roadmapReaders: roadmapReaders == const $CopyWithPlaceholder() ||
              roadmapReaders == null
          ? _value.roadmapReaders
          // ignore: cast_nullable_to_non_nullable
          : roadmapReaders as Map<int, RoadmapReadersModel>,
    );
  }
}

extension $RoadmapStateCopyWith on RoadmapState {
  /// Returns a callable class that can be used as follows: `instanceOfRoadmapState.copyWith(...)` or like so:`instanceOfRoadmapState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RoadmapStateCWProxy get copyWith => _$RoadmapStateCWProxyImpl(this);
}

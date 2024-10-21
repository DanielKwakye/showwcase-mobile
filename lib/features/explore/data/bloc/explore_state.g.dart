// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ExploreStateCWProxy {
  ExploreState status(ExploreStatus status);

  ExploreState message(String message);

  ExploreState trendingShows(List<ShowModel> trendingShows);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ExploreState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ExploreState(...).copyWith(id: 12, name: "My name")
  /// ````
  ExploreState call({
    ExploreStatus? status,
    String? message,
    List<ShowModel>? trendingShows,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfExploreState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfExploreState.copyWith.fieldName(...)`
class _$ExploreStateCWProxyImpl implements _$ExploreStateCWProxy {
  const _$ExploreStateCWProxyImpl(this._value);

  final ExploreState _value;

  @override
  ExploreState status(ExploreStatus status) => this(status: status);

  @override
  ExploreState message(String message) => this(message: message);

  @override
  ExploreState trendingShows(List<ShowModel> trendingShows) =>
      this(trendingShows: trendingShows);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ExploreState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ExploreState(...).copyWith(id: 12, name: "My name")
  /// ````
  ExploreState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? trendingShows = const $CopyWithPlaceholder(),
  }) {
    return ExploreState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as ExploreStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      trendingShows:
          trendingShows == const $CopyWithPlaceholder() || trendingShows == null
              ? _value.trendingShows
              // ignore: cast_nullable_to_non_nullable
              : trendingShows as List<ShowModel>,
    );
  }
}

extension $ExploreStateCopyWith on ExploreState {
  /// Returns a callable class that can be used as follows: `instanceOfExploreState.copyWith(...)` or like so:`instanceOfExploreState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ExploreStateCWProxy get copyWith => _$ExploreStateCWProxyImpl(this);
}

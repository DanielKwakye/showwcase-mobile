// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SeriesStateCWProxy {
  SeriesState status(SeriesStatus status);

  SeriesState message(String message);

  SeriesState series(List<SeriesModel> series);

  SeriesState data(dynamic data);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SeriesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SeriesState(...).copyWith(id: 12, name: "My name")
  /// ````
  SeriesState call({
    SeriesStatus? status,
    String? message,
    List<SeriesModel>? series,
    dynamic data,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSeriesState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSeriesState.copyWith.fieldName(...)`
class _$SeriesStateCWProxyImpl implements _$SeriesStateCWProxy {
  const _$SeriesStateCWProxyImpl(this._value);

  final SeriesState _value;

  @override
  SeriesState status(SeriesStatus status) => this(status: status);

  @override
  SeriesState message(String message) => this(message: message);

  @override
  SeriesState series(List<SeriesModel> series) => this(series: series);

  @override
  SeriesState data(dynamic data) => this(data: data);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SeriesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SeriesState(...).copyWith(id: 12, name: "My name")
  /// ````
  SeriesState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? series = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
  }) {
    return SeriesState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as SeriesStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      series: series == const $CopyWithPlaceholder() || series == null
          ? _value.series
          // ignore: cast_nullable_to_non_nullable
          : series as List<SeriesModel>,
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as dynamic,
    );
  }
}

extension $SeriesStateCopyWith on SeriesState {
  /// Returns a callable class that can be used as follows: `instanceOfSeriesState.copyWith(...)` or like so:`instanceOfSeriesState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SeriesStateCWProxy get copyWith => _$SeriesStateCWProxyImpl(this);
}

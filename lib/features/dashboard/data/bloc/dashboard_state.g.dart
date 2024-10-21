// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DashboardStateCWProxy {
  DashboardState status(DashboardStatus status);

  DashboardState dashboardModel(DashboardModel? dashboardModel);

  DashboardState threads(List<ThreadModel> threads);

  DashboardState shows(List<ShowModel> shows);

  DashboardState message(String message);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DashboardState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DashboardState(...).copyWith(id: 12, name: "My name")
  /// ````
  DashboardState call({
    DashboardStatus? status,
    DashboardModel? dashboardModel,
    List<ThreadModel>? threads,
    List<ShowModel>? shows,
    String? message,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDashboardState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDashboardState.copyWith.fieldName(...)`
class _$DashboardStateCWProxyImpl implements _$DashboardStateCWProxy {
  const _$DashboardStateCWProxyImpl(this._value);

  final DashboardState _value;

  @override
  DashboardState status(DashboardStatus status) => this(status: status);

  @override
  DashboardState dashboardModel(DashboardModel? dashboardModel) =>
      this(dashboardModel: dashboardModel);

  @override
  DashboardState threads(List<ThreadModel> threads) => this(threads: threads);

  @override
  DashboardState shows(List<ShowModel> shows) => this(shows: shows);

  @override
  DashboardState message(String message) => this(message: message);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DashboardState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DashboardState(...).copyWith(id: 12, name: "My name")
  /// ````
  DashboardState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? dashboardModel = const $CopyWithPlaceholder(),
    Object? threads = const $CopyWithPlaceholder(),
    Object? shows = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
  }) {
    return DashboardState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as DashboardStatus,
      dashboardModel: dashboardModel == const $CopyWithPlaceholder()
          ? _value.dashboardModel
          // ignore: cast_nullable_to_non_nullable
          : dashboardModel as DashboardModel?,
      threads: threads == const $CopyWithPlaceholder() || threads == null
          ? _value.threads
          // ignore: cast_nullable_to_non_nullable
          : threads as List<ThreadModel>,
      shows: shows == const $CopyWithPlaceholder() || shows == null
          ? _value.shows
          // ignore: cast_nullable_to_non_nullable
          : shows as List<ShowModel>,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
    );
  }
}

extension $DashboardStateCopyWith on DashboardState {
  /// Returns a callable class that can be used as follows: `instanceOfDashboardState.copyWith(...)` or like so:`instanceOfDashboardState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DashboardStateCWProxy get copyWith => _$DashboardStateCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `DashboardState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DashboardState(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  DashboardState copyWithNull({
    bool dashboardModel = false,
  }) {
    return DashboardState(
      status: status,
      dashboardModel: dashboardModel == true ? null : this.dashboardModel,
      threads: threads,
      shows: shows,
      message: message,
    );
  }
}

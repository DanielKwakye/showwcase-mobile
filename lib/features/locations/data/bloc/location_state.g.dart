// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LocationStateCWProxy {
  LocationState message(String message);

  LocationState status(LocationStatus status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LocationState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LocationState(...).copyWith(id: 12, name: "My name")
  /// ````
  LocationState call({
    String? message,
    LocationStatus? status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLocationState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLocationState.copyWith.fieldName(...)`
class _$LocationStateCWProxyImpl implements _$LocationStateCWProxy {
  const _$LocationStateCWProxyImpl(this._value);

  final LocationState _value;

  @override
  LocationState message(String message) => this(message: message);

  @override
  LocationState status(LocationStatus status) => this(status: status);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LocationState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LocationState(...).copyWith(id: 12, name: "My name")
  /// ````
  LocationState call({
    Object? message = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return LocationState(
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as LocationStatus,
    );
  }
}

extension $LocationStateCopyWith on LocationState {
  /// Returns a callable class that can be used as follows: `instanceOfLocationState.copyWith(...)` or like so:`instanceOfLocationState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LocationStateCWProxy get copyWith => _$LocationStateCWProxyImpl(this);
}

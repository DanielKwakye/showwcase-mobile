// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaces_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SpacesStateCWProxy {
  SpacesState message(String message);

  SpacesState status(SpacesStatus status);

  SpacesState ongoingSpaces(List<SpaceModel> ongoingSpaces);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SpacesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SpacesState(...).copyWith(id: 12, name: "My name")
  /// ````
  SpacesState call({
    String? message,
    SpacesStatus? status,
    List<SpaceModel>? ongoingSpaces,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSpacesState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSpacesState.copyWith.fieldName(...)`
class _$SpacesStateCWProxyImpl implements _$SpacesStateCWProxy {
  const _$SpacesStateCWProxyImpl(this._value);

  final SpacesState _value;

  @override
  SpacesState message(String message) => this(message: message);

  @override
  SpacesState status(SpacesStatus status) => this(status: status);

  @override
  SpacesState ongoingSpaces(List<SpaceModel> ongoingSpaces) =>
      this(ongoingSpaces: ongoingSpaces);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SpacesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SpacesState(...).copyWith(id: 12, name: "My name")
  /// ````
  SpacesState call({
    Object? message = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? ongoingSpaces = const $CopyWithPlaceholder(),
  }) {
    return SpacesState(
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as SpacesStatus,
      ongoingSpaces:
          ongoingSpaces == const $CopyWithPlaceholder() || ongoingSpaces == null
              ? _value.ongoingSpaces
              // ignore: cast_nullable_to_non_nullable
              : ongoingSpaces as List<SpaceModel>,
    );
  }
}

extension $SpacesStateCopyWith on SpacesState {
  /// Returns a callable class that can be used as follows: `instanceOfSpacesState.copyWith(...)` or like so:`instanceOfSpacesState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SpacesStateCWProxy get copyWith => _$SpacesStateCWProxyImpl(this);
}

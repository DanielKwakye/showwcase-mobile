// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circles_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CirclesStateCWProxy {
  CirclesState status(CircleStatus status);

  CirclesState message(String message);

  CirclesState reasons(List<CircleReasonModel> reasons);

  CirclesState data(dynamic data);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CirclesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CirclesState(...).copyWith(id: 12, name: "My name")
  /// ````
  CirclesState call({
    CircleStatus? status,
    String? message,
    List<CircleReasonModel>? reasons,
    dynamic data,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCirclesState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCirclesState.copyWith.fieldName(...)`
class _$CirclesStateCWProxyImpl implements _$CirclesStateCWProxy {
  const _$CirclesStateCWProxyImpl(this._value);

  final CirclesState _value;

  @override
  CirclesState status(CircleStatus status) => this(status: status);

  @override
  CirclesState message(String message) => this(message: message);

  @override
  CirclesState reasons(List<CircleReasonModel> reasons) =>
      this(reasons: reasons);

  @override
  CirclesState data(dynamic data) => this(data: data);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CirclesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CirclesState(...).copyWith(id: 12, name: "My name")
  /// ````
  CirclesState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
    Object? reasons = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
  }) {
    return CirclesState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as CircleStatus,
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      reasons: reasons == const $CopyWithPlaceholder() || reasons == null
          ? _value.reasons
          // ignore: cast_nullable_to_non_nullable
          : reasons as List<CircleReasonModel>,
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as dynamic,
    );
  }
}

extension $CirclesStateCopyWith on CirclesState {
  /// Returns a callable class that can be used as follows: `instanceOfCirclesState.copyWith(...)` or like so:`instanceOfCirclesState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CirclesStateCWProxy get copyWith => _$CirclesStateCWProxyImpl(this);
}

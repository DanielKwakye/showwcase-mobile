// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NotificationStateCWProxy {
  NotificationState message(String message);

  NotificationState status(NotificationStatus status);

  NotificationState total(int total);

  NotificationState notifications(List<NotificationModel> notifications);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationState(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationState call({
    String? message,
    NotificationStatus? status,
    int? total,
    List<NotificationModel>? notifications,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNotificationState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNotificationState.copyWith.fieldName(...)`
class _$NotificationStateCWProxyImpl implements _$NotificationStateCWProxy {
  const _$NotificationStateCWProxyImpl(this._value);

  final NotificationState _value;

  @override
  NotificationState message(String message) => this(message: message);

  @override
  NotificationState status(NotificationStatus status) => this(status: status);

  @override
  NotificationState total(int total) => this(total: total);

  @override
  NotificationState notifications(List<NotificationModel> notifications) =>
      this(notifications: notifications);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationState(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationState call({
    Object? message = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? total = const $CopyWithPlaceholder(),
    Object? notifications = const $CopyWithPlaceholder(),
  }) {
    return NotificationState(
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as NotificationStatus,
      total: total == const $CopyWithPlaceholder() || total == null
          ? _value.total
          // ignore: cast_nullable_to_non_nullable
          : total as int,
      notifications:
          notifications == const $CopyWithPlaceholder() || notifications == null
              ? _value.notifications
              // ignore: cast_nullable_to_non_nullable
              : notifications as List<NotificationModel>,
    );
  }
}

extension $NotificationStateCopyWith on NotificationState {
  /// Returns a callable class that can be used as follows: `instanceOfNotificationState.copyWith(...)` or like so:`instanceOfNotificationState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NotificationStateCWProxy get copyWith =>
      _$NotificationStateCWProxyImpl(this);
}

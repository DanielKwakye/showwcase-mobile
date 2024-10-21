// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guestbook_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GuestbookStateCWProxy {
  GuestbookState message(String message);

  GuestbookState status(GuestBookStatus status);

  GuestbookState data(dynamic data);

  GuestbookState guestBookMessages(List<GuestBookModel> guestBookMessages);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GuestbookState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GuestbookState(...).copyWith(id: 12, name: "My name")
  /// ````
  GuestbookState call({
    String? message,
    GuestBookStatus? status,
    dynamic data,
    List<GuestBookModel>? guestBookMessages,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGuestbookState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGuestbookState.copyWith.fieldName(...)`
class _$GuestbookStateCWProxyImpl implements _$GuestbookStateCWProxy {
  const _$GuestbookStateCWProxyImpl(this._value);

  final GuestbookState _value;

  @override
  GuestbookState message(String message) => this(message: message);

  @override
  GuestbookState status(GuestBookStatus status) => this(status: status);

  @override
  GuestbookState data(dynamic data) => this(data: data);

  @override
  GuestbookState guestBookMessages(List<GuestBookModel> guestBookMessages) =>
      this(guestBookMessages: guestBookMessages);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GuestbookState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GuestbookState(...).copyWith(id: 12, name: "My name")
  /// ````
  GuestbookState call({
    Object? message = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
    Object? guestBookMessages = const $CopyWithPlaceholder(),
  }) {
    return GuestbookState(
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as GuestBookStatus,
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as dynamic,
      guestBookMessages: guestBookMessages == const $CopyWithPlaceholder() ||
              guestBookMessages == null
          ? _value.guestBookMessages
          // ignore: cast_nullable_to_non_nullable
          : guestBookMessages as List<GuestBookModel>,
    );
  }
}

extension $GuestbookStateCopyWith on GuestbookState {
  /// Returns a callable class that can be used as follows: `instanceOfGuestbookState.copyWith(...)` or like so:`instanceOfGuestbookState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GuestbookStateCWProxy get copyWith => _$GuestbookStateCWProxyImpl(this);
}

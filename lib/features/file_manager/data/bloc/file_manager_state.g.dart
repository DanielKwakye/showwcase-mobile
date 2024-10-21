// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_manager_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FileManagerStateCWProxy {
  FileManagerState message(String message);

  FileManagerState status(FileManagerStatus status);

  FileManagerState fileItems(List<FileItem> fileItems);

  FileManagerState popularGifs(List<TenorResult> popularGifs);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FileManagerState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FileManagerState(...).copyWith(id: 12, name: "My name")
  /// ````
  FileManagerState call({
    String? message,
    FileManagerStatus? status,
    List<FileItem>? fileItems,
    List<TenorResult>? popularGifs,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFileManagerState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFileManagerState.copyWith.fieldName(...)`
class _$FileManagerStateCWProxyImpl implements _$FileManagerStateCWProxy {
  const _$FileManagerStateCWProxyImpl(this._value);

  final FileManagerState _value;

  @override
  FileManagerState message(String message) => this(message: message);

  @override
  FileManagerState status(FileManagerStatus status) => this(status: status);

  @override
  FileManagerState fileItems(List<FileItem> fileItems) =>
      this(fileItems: fileItems);

  @override
  FileManagerState popularGifs(List<TenorResult> popularGifs) =>
      this(popularGifs: popularGifs);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FileManagerState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FileManagerState(...).copyWith(id: 12, name: "My name")
  /// ````
  FileManagerState call({
    Object? message = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? fileItems = const $CopyWithPlaceholder(),
    Object? popularGifs = const $CopyWithPlaceholder(),
  }) {
    return FileManagerState(
      message: message == const $CopyWithPlaceholder() || message == null
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as FileManagerStatus,
      fileItems: fileItems == const $CopyWithPlaceholder() || fileItems == null
          ? _value.fileItems
          // ignore: cast_nullable_to_non_nullable
          : fileItems as List<FileItem>,
      popularGifs:
          popularGifs == const $CopyWithPlaceholder() || popularGifs == null
              ? _value.popularGifs
              // ignore: cast_nullable_to_non_nullable
              : popularGifs as List<TenorResult>,
    );
  }
}

extension $FileManagerStateCopyWith on FileManagerState {
  /// Returns a callable class that can be used as follows: `instanceOfFileManagerState.copyWith(...)` or like so:`instanceOfFileManagerState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FileManagerStateCWProxy get copyWith => _$FileManagerStateCWProxyImpl(this);
}

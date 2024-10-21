// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FileItemCWProxy {
  FileItem preSignedUrl(PreSignedUrlResponse? preSignedUrl);

  FileItem fileTag(int? fileTag);

  FileItem file(File? file);

  FileItem groupId(String? groupId);

  FileItem status(FileItemStatus? status);

  FileItem errorMessage(String? errorMessage);

  FileItem videoMediaId(String? videoMediaId);

  FileItem videoProgressValue(double? videoProgressValue);

  FileItem data(dynamic data);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FileItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FileItem(...).copyWith(id: 12, name: "My name")
  /// ````
  FileItem call({
    PreSignedUrlResponse? preSignedUrl,
    int? fileTag,
    File? file,
    String? groupId,
    FileItemStatus? status,
    String? errorMessage,
    String? videoMediaId,
    double? videoProgressValue,
    dynamic data,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFileItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFileItem.copyWith.fieldName(...)`
class _$FileItemCWProxyImpl implements _$FileItemCWProxy {
  const _$FileItemCWProxyImpl(this._value);

  final FileItem _value;

  @override
  FileItem preSignedUrl(PreSignedUrlResponse? preSignedUrl) =>
      this(preSignedUrl: preSignedUrl);

  @override
  FileItem fileTag(int? fileTag) => this(fileTag: fileTag);

  @override
  FileItem file(File? file) => this(file: file);

  @override
  FileItem groupId(String? groupId) => this(groupId: groupId);

  @override
  FileItem status(FileItemStatus? status) => this(status: status);

  @override
  FileItem errorMessage(String? errorMessage) =>
      this(errorMessage: errorMessage);

  @override
  FileItem videoMediaId(String? videoMediaId) =>
      this(videoMediaId: videoMediaId);

  @override
  FileItem videoProgressValue(double? videoProgressValue) =>
      this(videoProgressValue: videoProgressValue);

  @override
  FileItem data(dynamic data) => this(data: data);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FileItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FileItem(...).copyWith(id: 12, name: "My name")
  /// ````
  FileItem call({
    Object? preSignedUrl = const $CopyWithPlaceholder(),
    Object? fileTag = const $CopyWithPlaceholder(),
    Object? file = const $CopyWithPlaceholder(),
    Object? groupId = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? errorMessage = const $CopyWithPlaceholder(),
    Object? videoMediaId = const $CopyWithPlaceholder(),
    Object? videoProgressValue = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
  }) {
    return FileItem(
      preSignedUrl: preSignedUrl == const $CopyWithPlaceholder()
          ? _value.preSignedUrl
          // ignore: cast_nullable_to_non_nullable
          : preSignedUrl as PreSignedUrlResponse?,
      fileTag: fileTag == const $CopyWithPlaceholder()
          ? _value.fileTag
          // ignore: cast_nullable_to_non_nullable
          : fileTag as int?,
      file: file == const $CopyWithPlaceholder()
          ? _value.file
          // ignore: cast_nullable_to_non_nullable
          : file as File?,
      groupId: groupId == const $CopyWithPlaceholder()
          ? _value.groupId
          // ignore: cast_nullable_to_non_nullable
          : groupId as String?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as FileItemStatus?,
      errorMessage: errorMessage == const $CopyWithPlaceholder()
          ? _value.errorMessage
          // ignore: cast_nullable_to_non_nullable
          : errorMessage as String?,
      videoMediaId: videoMediaId == const $CopyWithPlaceholder()
          ? _value.videoMediaId
          // ignore: cast_nullable_to_non_nullable
          : videoMediaId as String?,
      videoProgressValue: videoProgressValue == const $CopyWithPlaceholder()
          ? _value.videoProgressValue
          // ignore: cast_nullable_to_non_nullable
          : videoProgressValue as double?,
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as dynamic,
    );
  }
}

extension $FileItemCopyWith on FileItem {
  /// Returns a callable class that can be used as follows: `instanceOfFileItem.copyWith(...)` or like so:`instanceOfFileItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FileItemCWProxy get copyWith => _$FileItemCWProxyImpl(this);
}

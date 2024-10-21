// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_signed_url_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PreSignedUrlResponseCWProxy {
  PreSignedUrlResponse url(String? url);

  PreSignedUrlResponse preSignedUrlFields(
      PreSignedUrlFields? preSignedUrlFields);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PreSignedUrlResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PreSignedUrlResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  PreSignedUrlResponse call({
    String? url,
    PreSignedUrlFields? preSignedUrlFields,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPreSignedUrlResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPreSignedUrlResponse.copyWith.fieldName(...)`
class _$PreSignedUrlResponseCWProxyImpl
    implements _$PreSignedUrlResponseCWProxy {
  const _$PreSignedUrlResponseCWProxyImpl(this._value);

  final PreSignedUrlResponse _value;

  @override
  PreSignedUrlResponse url(String? url) => this(url: url);

  @override
  PreSignedUrlResponse preSignedUrlFields(
          PreSignedUrlFields? preSignedUrlFields) =>
      this(preSignedUrlFields: preSignedUrlFields);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PreSignedUrlResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PreSignedUrlResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  PreSignedUrlResponse call({
    Object? url = const $CopyWithPlaceholder(),
    Object? preSignedUrlFields = const $CopyWithPlaceholder(),
  }) {
    return PreSignedUrlResponse(
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
      preSignedUrlFields: preSignedUrlFields == const $CopyWithPlaceholder()
          ? _value.preSignedUrlFields
          // ignore: cast_nullable_to_non_nullable
          : preSignedUrlFields as PreSignedUrlFields?,
    );
  }
}

extension $PreSignedUrlResponseCopyWith on PreSignedUrlResponse {
  /// Returns a callable class that can be used as follows: `instanceOfPreSignedUrlResponse.copyWith(...)` or like so:`instanceOfPreSignedUrlResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PreSignedUrlResponseCWProxy get copyWith =>
      _$PreSignedUrlResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreSignedUrlResponse _$PreSignedUrlResponseFromJson(
        Map<String, dynamic> json) =>
    PreSignedUrlResponse(
      url: json['url'] as String?,
      preSignedUrlFields: json['fields'] == null
          ? null
          : PreSignedUrlFields.fromJson(json['fields'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PreSignedUrlResponseToJson(
        PreSignedUrlResponse instance) =>
    <String, dynamic>{
      'url': instance.url,
      'fields': instance.preSignedUrlFields?.toJson(),
    };

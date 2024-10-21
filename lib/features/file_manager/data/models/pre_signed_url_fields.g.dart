// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_signed_url_fields.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreSignedUrlFields _$PreSignedUrlFieldsFromJson(Map<String, dynamic> json) =>
    PreSignedUrlFields(
      contentType: json['Content-Type'] as String?,
      key: json['key'] as String?,
      bucket: json['bucket'] as String?,
      xAmzAlgorithm: json['X-Amz-Algorithm'] as String?,
      xAmzCredential: json['X-Amz-Credential'] as String?,
      xAmzDate: json['X-Amz-Date'] as String?,
      policy: json['Policy'] as String?,
      xAmzSignature: json['X-Amz-Signature'] as String?,
      xAmzSecurityToken: json['X-Amz-Security-Token'] as String?,
    );

Map<String, dynamic> _$PreSignedUrlFieldsToJson(PreSignedUrlFields instance) =>
    <String, dynamic>{
      'Content-Type': instance.contentType,
      'key': instance.key,
      'bucket': instance.bucket,
      'X-Amz-Algorithm': instance.xAmzAlgorithm,
      'X-Amz-Credential': instance.xAmzCredential,
      'X-Amz-Date': instance.xAmzDate,
      'Policy': instance.policy,
      'X-Amz-Signature': instance.xAmzSignature,
      'X-Amz-Security-Token': instance.xAmzSecurityToken,
    };

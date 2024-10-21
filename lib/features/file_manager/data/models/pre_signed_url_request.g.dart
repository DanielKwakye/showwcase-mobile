// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_signed_url_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreSignedUrlRequest _$PreSignedUrlRequestFromJson(Map<String, dynamic> json) =>
    PreSignedUrlRequest(
      key: json['key'] as String?,
      contentType: json['contentType'] as String?,
      bucketName: json['bucketName'] as String?,
    );

Map<String, dynamic> _$PreSignedUrlRequestToJson(
        PreSignedUrlRequest instance) =>
    <String, dynamic>{
      'key': instance.key,
      'contentType': instance.contentType,
      'bucketName': instance.bucketName,
    };

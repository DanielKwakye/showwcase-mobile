// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoMetaModel _$VideoMetaModelFromJson(Map<String, dynamic> json) =>
    VideoMetaModel(
      filename: json['filename'] as String?,
      filetype: json['filetype'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$VideoMetaModelToJson(VideoMetaModel instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      'filetype': instance.filetype,
      'userId': instance.userId,
    };

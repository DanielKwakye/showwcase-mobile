// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_video_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowVideoBlockModel _$ShowVideoBlockModelFromJson(Map<String, dynamic> json) =>
    ShowVideoBlockModel(
      videoType: json['videoType'] as int?,
      caption: json['caption'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$ShowVideoBlockModelToJson(
        ShowVideoBlockModel instance) =>
    <String, dynamic>{
      'videoType': instance.videoType,
      'caption': instance.caption,
      'url': instance.url,
    };

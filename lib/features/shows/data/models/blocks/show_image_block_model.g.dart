// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_image_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowImageBlockModel _$ShowImageBlockModelFromJson(Map<String, dynamic> json) =>
    ShowImageBlockModel(
      mode: json['mode'] as int?,
      caption: json['caption'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$ShowImageBlockModelToJson(
        ShowImageBlockModel instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'caption': instance.caption,
      'url': instance.url,
    };

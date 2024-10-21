// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_preview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowPreviewModel _$ShowPreviewModelFromJson(Map<String, dynamic> json) =>
    ShowPreviewModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      images: json['images'] as List<dynamic>?,
      favicon: json['favicon'] as String?,
      type: json['type'] as String?,
      thread: json['thread'] == null
          ? null
          : ThreadModel.fromJson(json['thread'] as Map<String, dynamic>),
      show: json['show'] == null
          ? null
          : ShowModel.fromJson(json['show'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShowPreviewModelToJson(ShowPreviewModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'images': instance.images,
      'favicon': instance.favicon,
      'type': instance.type,
      'thread': instance.thread?.toJson(),
      'show': instance.show?.toJson(),
    };

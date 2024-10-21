// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_preview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedPreviewModel _$SharedPreviewModelFromJson(Map<String, dynamic> json) =>
    SharedPreviewModel(
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

Map<String, dynamic> _$SharedPreviewModelToJson(SharedPreviewModel instance) =>
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

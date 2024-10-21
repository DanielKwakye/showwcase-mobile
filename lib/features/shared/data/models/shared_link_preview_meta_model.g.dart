// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_link_preview_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedLinkPreviewMetaModel _$SharedLinkPreviewMetaModelFromJson(
        Map<String, dynamic> json) =>
    SharedLinkPreviewMetaModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String?).toList(),
      favicon: json['favicon'] as String?,
      type: json['type'] as String?,
      project: json['project'] == null
          ? null
          : ShowModel.fromJson(json['project'] as Map<String, dynamic>),
      thread: json['thread'] == null
          ? null
          : ThreadModel.fromJson(json['thread'] as Map<String, dynamic>),
      series: json['series'] == null
          ? null
          : SeriesModel.fromJson(json['series'] as Map<String, dynamic>),
      communityModel: json['community'] == null
          ? null
          : CommunityModel.fromJson(json['community'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SharedLinkPreviewMetaModelToJson(
        SharedLinkPreviewMetaModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'images': instance.images,
      'favicon': instance.favicon,
      'type': instance.type,
      'project': instance.project?.toJson(),
      'series': instance.series?.toJson(),
      'thread': instance.thread?.toJson(),
      'community': instance.communityModel?.toJson(),
    };

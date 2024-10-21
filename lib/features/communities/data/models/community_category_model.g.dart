// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityCategoryModel _$CommunityCategoryModelFromJson(
        Map<String, dynamic> json) =>
    CommunityCategoryModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
    );

Map<String, dynamic> _$CommunityCategoryModelToJson(
        CommunityCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

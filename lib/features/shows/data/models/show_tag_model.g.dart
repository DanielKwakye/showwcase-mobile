// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowTagModel _$ShowTagModelFromJson(Map<String, dynamic> json) => ShowTagModel(
      id: json['id'] as int?,
      tagDescription: json['tagDescription'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      communityTag: json['communityTag'] == null
          ? null
          : CommunityTagModel.fromJson(
              json['communityTag'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShowTagModelToJson(ShowTagModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tagDescription': instance.tagDescription,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'communityTag': instance.communityTag?.toJson(),
    };

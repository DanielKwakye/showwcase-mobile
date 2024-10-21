// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_social_link_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedSocialLinkIconModel _$SharedSocialLinkIconModelFromJson(
        Map<String, dynamic> json) =>
    SharedSocialLinkIconModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      label: json['label'] as String?,
      iconKey: json['iconKey'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SharedSocialLinkIconModelToJson(
        SharedSocialLinkIconModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'label': instance.label,
      'iconKey': instance.iconKey,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

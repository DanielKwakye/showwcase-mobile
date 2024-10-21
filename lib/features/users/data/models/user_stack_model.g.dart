// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stack_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStackModel _$UserStackModelFromJson(Map<String, dynamic> json) =>
    UserStackModel(
      id: json['id'] as int?,
      category: json['category'] as String?,
      subCategory: json['sub_category'] as String?,
      description: json['description'] as String?,
      name: json['name'] as String?,
      icon: json['icon'] as String?,
      iconUrl: json['iconUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isMatched: json['isMatched'] as bool?,
    );

Map<String, dynamic> _$UserStackModelToJson(UserStackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'sub_category': instance.subCategory,
      'description': instance.description,
      'name': instance.name,
      'icon': instance.icon,
      'iconUrl': instance.iconUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isMatched': instance.isMatched,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowContentModel _$ShowContentModelFromJson(Map<String, dynamic> json) =>
    ShowContentModel(
      blocks: (json['blocks'] as List<dynamic>?)
          ?.map((e) => ShowBlockModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lexicalBlock: json['lexicalBlock'] == null
          ? null
          : ShowLexicalBlockModel.fromJson(
              json['lexicalBlock'] as Map<String, dynamic>),
      category: json['category'] as String?,
      projectBlockType: json['projectBlockType'] as int?,
    );

Map<String, dynamic> _$ShowContentModelToJson(ShowContentModel instance) =>
    <String, dynamic>{
      'blocks': instance.blocks?.map((e) => e.toJson()).toList(),
      'lexicalBlock': instance.lexicalBlock?.toJson(),
      'category': instance.category,
      'projectBlockType': instance.projectBlockType,
    };

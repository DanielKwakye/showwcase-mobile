// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_bookmark_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowBookmarkBlockModel _$ShowBookmarkBlockModelFromJson(
        Map<String, dynamic> json) =>
    ShowBookmarkBlockModel(
      preview: json['preview'] == null
          ? null
          : SharedPreviewModel.fromJson(
              json['preview'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShowBookmarkBlockModelToJson(
        ShowBookmarkBlockModel instance) =>
    <String, dynamic>{
      'preview': instance.preview?.toJson(),
    };

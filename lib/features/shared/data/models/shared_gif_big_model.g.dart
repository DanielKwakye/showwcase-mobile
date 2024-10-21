// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_gif_big_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedGifBigModel _$SharedGifBigModelFromJson(Map<String, dynamic> json) =>
    SharedGifBigModel(
      url: json['url'] as String?,
      dims: (json['dims'] as List<dynamic>?)?.map((e) => e as int).toList(),
      size: json['size'] as int?,
      preview: json['preview'] as String?,
    );

Map<String, dynamic> _$SharedGifBigModelToJson(SharedGifBigModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'dims': instance.dims,
      'size': instance.size,
      'preview': instance.preview,
    };

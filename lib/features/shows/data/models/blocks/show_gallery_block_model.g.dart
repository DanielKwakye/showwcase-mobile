// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_gallery_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowGalleryBlockModel _$ShowGalleryBlockModelFromJson(
        Map<String, dynamic> json) =>
    ShowGalleryBlockModel(
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ShowImageBlockModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShowGalleryBlockModelToJson(
        ShowGalleryBlockModel instance) =>
    <String, dynamic>{
      'images': instance.images?.map((e) => e.toJson()).toList(),
    };

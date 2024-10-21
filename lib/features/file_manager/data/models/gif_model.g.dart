// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gif_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GifModel _$GifModelFromJson(Map<String, dynamic> json) => GifModel(
      big: json['big'] == null
          ? null
          : SharedGifBigModel.fromJson(json['big'] as Map<String, dynamic>),
      tiny: json['tiny'] == null
          ? null
          : SharedGifBigModel.fromJson(json['tiny'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GifModelToJson(GifModel instance) => <String, dynamic>{
      'big': instance.big?.toJson(),
      'tiny': instance.tiny?.toJson(),
    };

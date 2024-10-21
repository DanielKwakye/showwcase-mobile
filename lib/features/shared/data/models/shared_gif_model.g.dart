// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_gif_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedGifModel _$SharedGifModelFromJson(Map<String, dynamic> json) =>
    SharedGifModel(
      big: json['big'] == null
          ? null
          : SharedGifBigModel.fromJson(json['big'] as Map<String, dynamic>),
      tiny: json['tiny'] == null
          ? null
          : SharedGifBigModel.fromJson(json['tiny'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SharedGifModelToJson(SharedGifModel instance) =>
    <String, dynamic>{
      'big': instance.big?.toJson(),
      'tiny': instance.tiny?.toJson(),
    };

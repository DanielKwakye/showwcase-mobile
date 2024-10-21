// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesSettingsModel _$SeriesSettingsModelFromJson(Map<String, dynamic> json) =>
    SeriesSettingsModel(
      enableReview: json['enableReview'] as bool?,
      enableProgress: json['enableProgress'] as bool?,
      language: json['language'] as String?,
    );

Map<String, dynamic> _$SeriesSettingsModelToJson(
        SeriesSettingsModel instance) =>
    <String, dynamic>{
      'enableReview': instance.enableReview,
      'enableProgress': instance.enableProgress,
      'language': instance.language,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoStatusModel _$VideoStatusModelFromJson(Map<String, dynamic> json) =>
    VideoStatusModel(
      state: json['state'] as String?,
      pctComplete: json['pctComplete'] as String?,
      errorReasonCode: json['errorReasonCode'] as String?,
      errorReasonText: json['errorReasonText'] as String?,
    );

Map<String, dynamic> _$VideoStatusModelToJson(VideoStatusModel instance) =>
    <String, dynamic>{
      'state': instance.state,
      'pctComplete': instance.pctComplete,
      'errorReasonCode': instance.errorReasonCode,
      'errorReasonText': instance.errorReasonText,
    };

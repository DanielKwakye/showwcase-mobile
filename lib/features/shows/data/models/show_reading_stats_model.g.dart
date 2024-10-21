// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_reading_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowReadingStatsModel _$ShowReadingStatsModelFromJson(
        Map<String, dynamic> json) =>
    ShowReadingStatsModel(
      text: json['text'] as String?,
      time: json['time'] as num?,
      words: json['words'] as num?,
      minutes: json['minutes'] as num?,
    );

Map<String, dynamic> _$ShowReadingStatsModelToJson(
        ShowReadingStatsModel instance) =>
    <String, dynamic>{
      'text': instance.text,
      'time': instance.time,
      'words': instance.words,
      'minutes': instance.minutes,
    };

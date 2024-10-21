// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_playback_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoPlaybackModel _$VideoPlaybackModelFromJson(Map<String, dynamic> json) =>
    VideoPlaybackModel(
      hls: json['hls'] as String?,
      dash: json['dash'] as String?,
    );

Map<String, dynamic> _$VideoPlaybackModelToJson(VideoPlaybackModel instance) =>
    <String, dynamic>{
      'hls': instance.hls,
      'dash': instance.dash,
    };

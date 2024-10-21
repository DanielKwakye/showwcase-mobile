// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoModel _$VideoModelFromJson(Map<String, dynamic> json) => VideoModel(
      uid: json['uid'] as String?,
      thumbnail: json['thumbnail'] as String?,
      thumbnailTimestampPct:
          (json['thumbnailTimestampPct'] as num?)?.toDouble(),
      readyToStream: json['readyToStream'] as bool?,
      status: json['status'] == null
          ? null
          : VideoStatusModel.fromJson(json['status'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : VideoMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      modified: json['modified'] == null
          ? null
          : DateTime.parse(json['modified'] as String),
      size: (json['size'] as num?)?.toDouble(),
      preview: json['preview'] as String?,
      allowedOrigins: json['allowedOrigins'] as List<dynamic>?,
      requireSignedUrLs: json['requireSignedUrLs'] as bool?,
      uploaded: json['uploaded'] == null
          ? null
          : DateTime.parse(json['uploaded'] as String),
      uploadExpiry: json['uploadExpiry'] == null
          ? null
          : DateTime.parse(json['uploadExpiry'] as String),
      maxSizeBytes: json['maxSizeBytes'],
      maxDurationSeconds: json['maxDurationSeconds'] as int?,
      duration: (json['duration'] as num?)?.toDouble(),
      input: json['input'] == null
          ? null
          : VideoInputModel.fromJson(json['input'] as Map<String, dynamic>),
      playback: json['playback'] == null
          ? null
          : VideoPlaybackModel.fromJson(
              json['playback'] as Map<String, dynamic>),
      watermark: json['watermark'],
    );

Map<String, dynamic> _$VideoModelToJson(VideoModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'thumbnail': instance.thumbnail,
      'thumbnailTimestampPct': instance.thumbnailTimestampPct,
      'readyToStream': instance.readyToStream,
      'status': instance.status?.toJson(),
      'meta': instance.meta?.toJson(),
      'created': instance.created?.toIso8601String(),
      'modified': instance.modified?.toIso8601String(),
      'size': instance.size,
      'preview': instance.preview,
      'allowedOrigins': instance.allowedOrigins,
      'requireSignedUrLs': instance.requireSignedUrLs,
      'uploaded': instance.uploaded?.toIso8601String(),
      'uploadExpiry': instance.uploadExpiry?.toIso8601String(),
      'maxSizeBytes': instance.maxSizeBytes,
      'maxDurationSeconds': instance.maxDurationSeconds,
      'duration': instance.duration,
      'input': instance.input?.toJson(),
      'playback': instance.playback?.toJson(),
      'watermark': instance.watermark,
    };

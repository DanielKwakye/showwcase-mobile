import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/file_manager/data/models/video_input_model.dart';
import 'package:showwcase_v3/features/file_manager/data/models/video_meta_model.dart';
import 'package:showwcase_v3/features/file_manager/data/models/video_playback_model.dart';
import 'package:showwcase_v3/features/file_manager/data/models/video_status_model.dart';

part 'video_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VideoModel extends Equatable {

  const VideoModel({
    this.uid,
    this.thumbnail,
    this.thumbnailTimestampPct,
    this.readyToStream,
    this.status,
    this.meta,
    this.created,
    this.modified,
    this.size,
    this.preview,
    this.allowedOrigins,
    this.requireSignedUrLs,
    this.uploaded,
    this.uploadExpiry,
    this.maxSizeBytes,
    this.maxDurationSeconds,
    this.duration,
    this.input,
    this.playback,
    this.watermark,
  });

  final String? uid;
  final String? thumbnail;
  final double? thumbnailTimestampPct;
  final bool? readyToStream;
  final VideoStatusModel? status;
  final VideoMetaModel? meta;
  final DateTime? created;
  final DateTime? modified;
  final double? size;
  final String? preview;
  final List<dynamic>? allowedOrigins;
  final bool? requireSignedUrLs;
  final DateTime? uploaded;
  final DateTime? uploadExpiry;
  final dynamic maxSizeBytes;
  final int? maxDurationSeconds;
  final double? duration;
  final VideoInputModel? input;
  final VideoPlaybackModel? playback;
  final dynamic watermark;

  factory VideoModel.fromJson(Map<String, dynamic> json) => _$VideoModelFromJson(json);
  Map<String, dynamic> toJson() => _$VideoModelToJson(this);

  @override
  List<Object?> get props => [uid];
}
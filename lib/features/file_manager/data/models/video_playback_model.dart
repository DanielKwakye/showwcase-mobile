import 'package:json_annotation/json_annotation.dart';

part 'video_playback_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VideoPlaybackModel {
  
  VideoPlaybackModel({
    this.hls,
    this.dash,
  });

  String? hls;
  String? dash;

  factory VideoPlaybackModel.fromJson(Map<String, dynamic> json) => _$VideoPlaybackModelFromJson(json);
  Map<String, dynamic> toJson() => _$VideoPlaybackModelToJson(this);
  
}
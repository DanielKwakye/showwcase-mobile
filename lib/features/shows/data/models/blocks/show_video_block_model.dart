import 'package:json_annotation/json_annotation.dart';

part 'show_video_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowVideoBlockModel {
  const ShowVideoBlockModel({
    this.videoType,
    this.caption,
    this.url,
  });

  final int? videoType;
  final String? caption;
  final String? url;

  factory ShowVideoBlockModel.fromJson(Map<String, dynamic> json) => _$ShowVideoBlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowVideoBlockModelToJson(this);
  
}
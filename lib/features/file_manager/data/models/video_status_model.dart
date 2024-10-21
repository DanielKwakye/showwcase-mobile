import 'package:json_annotation/json_annotation.dart';

part 'video_status_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VideoStatusModel {
  
  const VideoStatusModel({
    this.state,
    this.pctComplete,
    this.errorReasonCode,
    this.errorReasonText,
  });

  final String? state;
  final String? pctComplete;
  final String? errorReasonCode;
  final String? errorReasonText;

  factory VideoStatusModel.fromJson(Map<String, dynamic> json) => _$VideoStatusModelFromJson(json);
  Map<String, dynamic> toJson() => _$VideoStatusModelToJson(this);
  
}
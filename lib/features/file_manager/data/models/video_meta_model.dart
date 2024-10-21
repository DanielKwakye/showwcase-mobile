import 'package:json_annotation/json_annotation.dart';

part 'video_meta_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VideoMetaModel {
  
  VideoMetaModel({
    this.filename,
    this.filetype,
    this.userId,
  });

  String? filename;
  String? filetype;
  String? userId;

  factory VideoMetaModel.fromJson(Map<String, dynamic> json) => _$VideoMetaModelFromJson(json);
  Map<String, dynamic> toJson() => _$VideoMetaModelToJson(this);
  
}
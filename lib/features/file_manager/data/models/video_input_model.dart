import 'package:json_annotation/json_annotation.dart';

part 'video_input_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VideoInputModel {

  VideoInputModel({
    this.width,
    this.height,
  });

  int? width;
  int? height;

  factory VideoInputModel.fromJson(Map<String, dynamic> json) => _$VideoInputModelFromJson(json);
  Map<String, dynamic> toJson() => _$VideoInputModelToJson(this);
  
}
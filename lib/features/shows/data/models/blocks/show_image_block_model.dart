
import 'package:json_annotation/json_annotation.dart';

part 'show_image_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowImageBlockModel {

  const ShowImageBlockModel({
    this.mode,
    this.caption,
    this.url,
  });

  final int? mode;
  final String? caption;
  final String? url;

  factory ShowImageBlockModel.fromJson(Map<String, dynamic> json) => _$ShowImageBlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowImageBlockModelToJson(this);

}
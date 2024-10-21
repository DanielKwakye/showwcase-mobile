import 'package:json_annotation/json_annotation.dart';

part 'show_thread_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowThreadBlockModel {
  
  const ShowThreadBlockModel({
    this.url,
  });
  final String? url;

  factory ShowThreadBlockModel.fromJson(Map<String, dynamic> json) => _$ShowThreadBlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowThreadBlockModelToJson(this);
}
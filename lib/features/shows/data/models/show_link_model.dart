import 'package:json_annotation/json_annotation.dart';

part 'show_link_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowLinkModel {
  const ShowLinkModel({
    this.title,
    this.type,
    this.value,
  });

  final String? title;
  final int? type;
  final String? value;

  factory ShowLinkModel.fromJson(Map<String, dynamic> json) => _$ShowLinkModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowLinkModelToJson(this);
  
}
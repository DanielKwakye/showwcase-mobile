import 'package:json_annotation/json_annotation.dart';

part 'circle_reason_model.g.dart';

@JsonSerializable()
class CircleReasonModel {
  final String? type;
  final String? name;
  final String? category;
  
  const CircleReasonModel({this.type, this.name, this.category});

  factory CircleReasonModel.fromJson(Map<String, dynamic> json) => _$CircleReasonModelFromJson(json);
  Map<String, dynamic> toJson() => _$CircleReasonModelToJson(this);
  
}
import 'package:json_annotation/json_annotation.dart';

part 'job_type_model.g.dart';

@JsonSerializable(explicitToJson: true)
class JobTypeModel {
  const JobTypeModel({
    this.value,
    this.label,
  });

  final String? value;
  final String? label;

  factory JobTypeModel.fromJson(Map<String, dynamic> json) => _$JobTypeModelFromJson(json);
  Map<String, dynamic> toJson() => _$JobTypeModelToJson(this);

}
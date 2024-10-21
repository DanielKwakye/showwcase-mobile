import 'package:json_annotation/json_annotation.dart';

part 'company_stage_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CompanyStageModel {

  const CompanyStageModel({
    this.id,
    this.label,
  });

  final int? id;
  final String? label;

  factory CompanyStageModel.fromJson(Map<String, dynamic> json) => _$CompanyStageModelFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyStageModelToJson(this);

}
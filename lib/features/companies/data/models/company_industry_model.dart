import 'package:json_annotation/json_annotation.dart';

part 'company_industry_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CompanyIndustryModel {

  const CompanyIndustryModel({
    this.id,
    this.name,
  });

  final int? id;
  final String? name;

  factory CompanyIndustryModel.fromJson(Map<String, dynamic> json) => _$CompanyIndustryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyIndustryModelToJson(this);

}
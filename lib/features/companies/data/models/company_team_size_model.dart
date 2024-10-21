import 'package:json_annotation/json_annotation.dart';

part 'company_team_size_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CompanyTeamSizeModel {

  const CompanyTeamSizeModel({
    this.id,
    this.value,
  });

  final int? id;
  final String? value;

  factory CompanyTeamSizeModel.fromJson(Map<String, dynamic> json) => _$CompanyTeamSizeModelFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyTeamSizeModelToJson(this);

}
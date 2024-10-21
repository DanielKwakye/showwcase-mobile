import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:showwcase_v3/features/companies/data/models/company_industry_model.dart';
import 'package:showwcase_v3/features/companies/data/models/company_team_size_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_stack_model.dart';

import 'job_type_model.dart';

part 'job_filters_model.g.dart';


@CopyWith()
class JobFiltersModel extends Equatable {

  const JobFiltersModel({
    this.locations,
    this.types,
    this.positions,
    this.stacks,
    this.teamSizes,
    this.industries,
  });

  final List<Map<String, dynamic>>? locations;
  final List<Map<String, dynamic>>? types;
  final List<Map<String, dynamic>>? positions;
  final List<Map<String, dynamic>>? stacks;
  final List<Map<String, dynamic>>? teamSizes;
  final List<Map<String, dynamic>>? industries;

  factory JobFiltersModel.fromJson(Map<String, dynamic> json) => JobFiltersModel(
    locations: json["locations"] == null ? null : [ for (var v in json['locations'] as List )     { "filter": v, "selected" : false } ],
    types: json["types"] == null ? null : [ for (var v in json['types'] as List)                  { "filter": JobTypeModel.fromJson(v), "selected" : false } ],
    positions: json["positions"] == null ? null : [ for (var v in json['positions'] as List )     {"filter": v, "selected" : false} ],
    stacks: json["stacks"] == null ? null : [ for (var v in json['stacks'] as List)               { "filter": UserStackModel.fromJson(v), "selected" : false } ], //List<Stack>.from(json["stacks"].map((x) => Stack.fromJson(x))),
    teamSizes: json["teamSizes"] == null ? null : [ for (var v in json['teamSizes'] as List)      { "filter": CompanyTeamSizeModel.fromJson(v), "selected" : false } ], //List<TeamSize>.from(json["teamSizes"].map((x) => TeamSize.fromJson(x))),
    industries: json["industries"] == null ? null : [ for (var v in json['industries'] as List)   { "filter": CompanyIndustryModel.fromJson(v), "selected" : false } ] //List<Industry>.from(json["industries"].map((x) => Industry.fromJson(x))),
  );

  @override
  List<Object?> get props => [locations, types, positions, stacks, teamSizes, industries];


}


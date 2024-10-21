import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/shared/data/models/shared_time_zone_model.dart';

part 'user_job_preference_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
@CopyWith()
class UserJobPreferenceModel extends Equatable {

  const UserJobPreferenceModel({
    this.types,
    this.roleType,
    this.timezone,
    this.allTimeZone,
    this.problem,
    this.isJunior,
    this.salaryFrom,
    this.salaryTo,
    this.attributes,
    this.companySize,
    this.industries,
    this.companyValues,
    this.status
  });

  final List<String>? types;
  final List<String>? roleType;
  final List<SharedTimeZoneModel>? timezone;
  final bool? allTimeZone;
  final String? problem;
  final bool? isJunior;
  final int? salaryFrom;
  final int? salaryTo;
  final List<String>? attributes;
  final List<String>? companySize;
  final List<String>? industries;
  final List<String>? companyValues;
  final String? status;


  factory UserJobPreferenceModel.fromJson(Map<String, dynamic> json) => _$UserJobPreferenceModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserJobPreferenceModelToJson(this);


  @override
  List<Object?> get props => [types, roleType, timezone, allTimeZone, ];
}


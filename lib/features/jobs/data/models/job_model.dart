import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/companies/data/models/company_model.dart';
import 'package:showwcase_v3/features/companies/data/models/company_size_model.dart';
import 'package:showwcase_v3/features/jobs/data/models/salary_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_stack_model.dart';

part 'job_model.g.dart';

@JsonSerializable()
@CopyWith()
class JobModel extends Equatable{
  const JobModel({
    this.id,
    this.userId,
    this.slug,
    this.remoteOkId,
    this.weworkremotelyId,
    this.companyId,
    this.title,
    this.type,
    this.isApproved,
    this.roleId,
    this.status,
    this.arrangement,
    this.experience,
    // this.salaryFrom,
    // this.salaryTo,
    this.equityFrom,
    this.equityTo,
    this.location,
    this.currency,
    this.description,
    this.structure,
    this.publishedDate,
    this.applyUrl,
    this.views,
    this.visits,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.sizeId,
    this.stacks,
    this.salaryRange,
    this.recruitment,
    this.company,
    this.timezone,
    this.score,
    this.hasBookmarked,
    this.hasApplied,
    this.salary
  });

  final int? id;
  final int? userId;
  final String? slug;
  final int? remoteOkId;
  final String? weworkremotelyId;
  final int? companyId;
  final String? title;
  final String? type;
  final bool? isApproved;
  final int? roleId;
  final String? status;
  final String? arrangement;
  final String? experience;
  // final int? salaryFrom;
  // final int? salaryTo;
  final SalaryModel? salary;
  final int? equityFrom;
  final int? equityTo;
  final String? location;
  final String? currency;
  final String? description;
  final String? structure;
  @JsonKey(fromJson: _publishedDateFromJson)
  final DateTime? publishedDate;
  final String? applyUrl;
  final int? views;
  final int? visits;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int? sizeId;
  final List<UserStackModel>? stacks;
  final String? salaryRange;
  final String? recruitment;
  final CompanyModel? company;
  final CompanySizeModel? timezone;
  final int? score;
  final bool? hasApplied;
  final bool? hasBookmarked;


  @override
  List<Object?> get props => [id, title, description, salaryRange, remoteOkId, company, hasBookmarked, hasApplied];

  factory JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);
  Map<String, dynamic> toJson() => _$JobModelToJson(this);

  // publishedDate
  static DateTime? _publishedDateFromJson( jsonData ) =>
          jsonData is String ? DateTime.parse(jsonData)
          : jsonData is int ? DateTime.fromMillisecondsSinceEpoch(jsonData)
          : null;

}



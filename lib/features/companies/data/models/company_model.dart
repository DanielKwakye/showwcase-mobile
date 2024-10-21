import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/companies/data/models/company_industry_model.dart';
import 'package:showwcase_v3/features/companies/data/models/company_size_model.dart';
import 'package:showwcase_v3/features/companies/data/models/company_stage_model.dart';

part 'company_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CompanyModel extends Equatable {

  final int? id;
  final String? name;
  final String? slug;
  final String? location;
  final String? description;
  final String? oneLiner;
  final String? logo;
  final String? logoUrl;
  final String? url;
  final int? employerId;
  final int? sizeId;
  final List<dynamic>? socials; // { "id": String ,"name": String, "value": String, "tooltip": String }
  final int? totalJobs;
  final int? industryId;
  final int? investmentStageId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final CompanySizeModel? size;
  final CompanyIndustryModel? industry;
  final CompanyStageModel? stage;

  const CompanyModel({
    this.id,
    this.name,
    this.slug,
    this.location,
    this.description,
    this.oneLiner,
    this.logo,
    this.logoUrl,
    this.url,
    this.employerId,
    this.sizeId,
    this.socials,
    this.totalJobs,
    this.industryId,
    this.investmentStageId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.size,
    this.industry,
    this.stage,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => _$CompanyModelFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);

  @override
  List<Object?> get props => [id, logoUrl, name, slug];


}
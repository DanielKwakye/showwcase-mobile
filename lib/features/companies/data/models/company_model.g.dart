// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) => CompanyModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      location: json['location'] as String?,
      description: json['description'] as String?,
      oneLiner: json['oneLiner'] as String?,
      logo: json['logo'] as String?,
      logoUrl: json['logoUrl'] as String?,
      url: json['url'] as String?,
      employerId: json['employerId'] as int?,
      sizeId: json['sizeId'] as int?,
      socials: json['socials'] as List<dynamic>?,
      totalJobs: json['totalJobs'] as int?,
      industryId: json['industryId'] as int?,
      investmentStageId: json['investmentStageId'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      size: json['size'] == null
          ? null
          : CompanySizeModel.fromJson(json['size'] as Map<String, dynamic>),
      industry: json['industry'] == null
          ? null
          : CompanyIndustryModel.fromJson(
              json['industry'] as Map<String, dynamic>),
      stage: json['stage'] == null
          ? null
          : CompanyStageModel.fromJson(json['stage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompanyModelToJson(CompanyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'location': instance.location,
      'description': instance.description,
      'oneLiner': instance.oneLiner,
      'logo': instance.logo,
      'logoUrl': instance.logoUrl,
      'url': instance.url,
      'employerId': instance.employerId,
      'sizeId': instance.sizeId,
      'socials': instance.socials,
      'totalJobs': instance.totalJobs,
      'industryId': instance.industryId,
      'investmentStageId': instance.investmentStageId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'size': instance.size?.toJson(),
      'industry': instance.industry?.toJson(),
      'stage': instance.stage?.toJson(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_custom_domain_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCustomDomainModel _$UserCustomDomainModelFromJson(
        Map<String, dynamic> json) =>
    UserCustomDomainModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      domain: json['domain'] as String?,
      virtualId: json['virtualId'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserCustomDomainModelToJson(
        UserCustomDomainModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'domain': instance.domain,
      'virtualId': instance.virtualId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_worked_with_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowWorkedWithModel _$ShowWorkedWithModelFromJson(Map<String, dynamic> json) =>
    ShowWorkedWithModel(
      id: json['id'] as num?,
      userId: json['userId'] as int?,
      colleagueId: json['colleagueId'] as int?,
      projectId: json['projectId'] as int?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      colleague: json['colleague'] == null
          ? null
          : UserModel.fromJson(json['colleague'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShowWorkedWithModelToJson(
        ShowWorkedWithModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'colleagueId': instance.colleagueId,
      'projectId': instance.projectId,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'colleague': instance.colleague?.toJson(),
    };

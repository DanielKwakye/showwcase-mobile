// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowEventModel _$ShowEventModelFromJson(Map<String, dynamic> json) =>
    ShowEventModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      project: json['project'] == null
          ? null
          : ShowModel.fromJson(json['project'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool?,
      attendees: (json['attendees'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShowEventModelToJson(ShowEventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'project': instance.project?.toJson(),
      'user': instance.user?.toJson(),
      'isActive': instance.isActive,
      'attendees': instance.attendees?.map((e) => e.toJson()).toList(),
    };

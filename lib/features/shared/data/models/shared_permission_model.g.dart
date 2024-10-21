// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_permission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedPermissionsModel _$SharedPermissionsModelFromJson(
        Map<String, dynamic> json) =>
    SharedPermissionsModel(
      admin: json['admin'] as bool?,
      maintain: json['maintain'] as bool?,
      push: json['push'] as bool?,
      triage: json['triage'] as bool?,
      pull: json['pull'] as bool?,
    );

Map<String, dynamic> _$SharedPermissionsModelToJson(
        SharedPermissionsModel instance) =>
    <String, dynamic>{
      'admin': instance.admin,
      'maintain': instance.maintain,
      'push': instance.push,
      'triage': instance.triage,
      'pull': instance.pull,
    };

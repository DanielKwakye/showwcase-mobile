// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_module_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModuleModel _$UserModuleModelFromJson(Map<String, dynamic> json) =>
    UserModuleModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      visible: json['visible'] as bool?,
      type: json['type'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$UserModuleModelToJson(UserModuleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'visible': instance.visible,
      'type': instance.type,
      'data': instance.data,
    };

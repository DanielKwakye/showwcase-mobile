// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_size_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanySizeModel _$CompanySizeModelFromJson(Map<String, dynamic> json) =>
    CompanySizeModel(
      id: json['id'] as int?,
      label: json['label'] as String?,
      value: json['value'] as String?,
      offset: json['offset'] as int?,
    );

Map<String, dynamic> _$CompanySizeModelToJson(CompanySizeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'value': instance.value,
      'offset': instance.offset,
    };

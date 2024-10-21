// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalaryModel _$SalaryModelFromJson(Map<String, dynamic> json) => SalaryModel(
      from: json['from'] as num?,
      to: json['to'] as num?,
      range: json['range'] as String?,
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$SalaryModelToJson(SalaryModel instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'range': instance.range,
      'currency': instance.currency,
    };

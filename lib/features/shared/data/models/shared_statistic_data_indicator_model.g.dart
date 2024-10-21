// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_statistic_data_indicator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedStatisticDataIndicatorModel _$SharedStatisticDataIndicatorModelFromJson(
        Map<String, dynamic> json) =>
    SharedStatisticDataIndicatorModel(
      label: json['label'] as String?,
      visible: json['visible'] as bool?,
      value: json['value'] as int?,
      isOther: json['isOther'] as bool?,
    );

Map<String, dynamic> _$SharedStatisticDataIndicatorModelToJson(
        SharedStatisticDataIndicatorModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'visible': instance.visible,
      'value': instance.value,
      'isOther': instance.isOther,
    };

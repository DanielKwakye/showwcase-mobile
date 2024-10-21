// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_statistic_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowStatisticBlockModel _$ShowStatisticBlockModelFromJson(
        Map<String, dynamic> json) =>
    ShowStatisticBlockModel(
      selectedRepository: json['selectedRepository'] == null
          ? null
          : SharedRepositoryModel.fromJson(
              json['selectedRepository'] as Map<String, dynamic>),
      data: json['data'] == null
          ? null
          : SharedStatisticDataModel.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShowStatisticBlockModelToJson(
        ShowStatisticBlockModel instance) =>
    <String, dynamic>{
      'selectedRepository': instance.selectedRepository?.toJson(),
      'data': instance.data?.toJson(),
    };

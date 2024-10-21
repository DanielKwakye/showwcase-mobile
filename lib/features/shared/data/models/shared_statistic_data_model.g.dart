// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_statistic_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedStatisticDataModel _$SharedStatisticDataModelFromJson(
        Map<String, dynamic> json) =>
    SharedStatisticDataModel(
      indicators: (json['indicators'] as List<dynamic>?)
          ?.map((e) => SharedStatisticDataIndicatorModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      indicatorsVisible: json['indicatorsVisible'] as bool?,
      languages: json['languages'] as Map<String, dynamic>?,
      languagesVisible: json['languagesVisible'] as bool?,
      collaborators: (json['collaborators'] as List<dynamic>?)
          ?.map((e) => SharedRepositoryCollaboratorModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SharedStatisticDataModelToJson(
        SharedStatisticDataModel instance) =>
    <String, dynamic>{
      'indicators': instance.indicators?.map((e) => e.toJson()).toList(),
      'indicatorsVisible': instance.indicatorsVisible,
      'languages': instance.languages,
      'languagesVisible': instance.languagesVisible,
      'collaborators': instance.collaborators?.map((e) => e.toJson()).toList(),
    };

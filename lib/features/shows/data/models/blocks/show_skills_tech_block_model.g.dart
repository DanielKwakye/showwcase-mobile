// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_skills_tech_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowSkillsTechBlockModel _$ShowSkillsTechBlockModelFromJson(
        Map<String, dynamic> json) =>
    ShowSkillsTechBlockModel(
      stacks: (json['stacks'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => UserStackModel.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );

Map<String, dynamic> _$ShowSkillsTechBlockModelToJson(
        ShowSkillsTechBlockModel instance) =>
    <String, dynamic>{
      'stacks': instance.stacks
          ?.map((k, e) => MapEntry(k, e.map((e) => e.toJson()).toList())),
    };

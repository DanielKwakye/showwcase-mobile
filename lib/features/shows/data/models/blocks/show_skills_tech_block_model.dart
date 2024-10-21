import 'package:json_annotation/json_annotation.dart';
import 'package:showwcase_v3/features/users/data/models/user_stack_model.dart';

part 'show_skills_tech_block_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShowSkillsTechBlockModel {

  final Map<String, List<UserStackModel>>? stacks;
  const ShowSkillsTechBlockModel({this.stacks});

  factory ShowSkillsTechBlockModel.fromJson(Map<String, dynamic> json) => _$ShowSkillsTechBlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowSkillsTechBlockModelToJson(this);

}